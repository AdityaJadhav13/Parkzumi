import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../data/pilot_seed.dart';
import '../domain/assessment.dart';
import '../domain/models.dart';
import '../domain/time_ist.dart';
import '../platform/location.dart';
import 'context_sheet.dart';
import 'spot_sheet.dart';
import 'widgets.dart';

/// Bumped when the companion bubble asks to check where the rider is.
class CheckHereRequest extends Notifier<int> {
  @override
  int build() => 0;
  void fire() => state++;
}

final checkHereRequestProvider = NotifierProvider<CheckHereRequest, int>(CheckHereRequest.new);

class CheckScreen extends ConsumerStatefulWidget {
  const CheckScreen({super.key});

  @override
  ConsumerState<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends ConsumerState<CheckScreen> {
  final _map = MapController();
  String? _selected;

  LatLng _ll(GeoPoint p) => LatLng(p.lat, p.lng);

  Future<void> _locate({bool openNearest = false}) async {
    await ref.read(locationProvider.notifier).refresh();
    final view = ref.read(assessmentsProvider);
    final here = view?.here;
    if (view == null || here == null || !view.inPilotArea) {
      _map.move(_ll(pilotCentre), 17);
      return;
    }
    _map.move(_ll(here.point), 18);
    if (!openNearest || !mounted) return;
    final nearest = view.distances.entries.reduce((a, b) => a.value <= b.value ? a : b);
    // Only open a spot when the fix can tell spots apart; otherwise let the rider pick.
    if (nearest.value <= 40 && here.accuracyM <= 30) _open(nearest.key);
  }

  void _open(String spotId) {
    setState(() => _selected = spotId);
    showSpotSheet(context, spotId).whenComplete(() {
      if (mounted) setState(() => _selected = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(checkHereRequestProvider, (_, _) => _locate(openNearest: true));
    final pz = Pz.of(context);
    final view = ref.watch(assessmentsProvider);
    final location = ref.watch(locationProvider);
    final shared = ref.watch(sharedPlaceProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: FlutterMap(
            mapController: _map,
            options: MapOptions(
              initialCenter: _ll(pilotCentre),
              initialZoom: 17,
              minZoom: 13,
              maxZoom: 19,
              backgroundColor: pz.background,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
            ),
            children: [
              // shortcut: public OSM tiles are fine for a demo, not for a shipped app — move to a
              // keyed provider or self-hosted vector tiles before release.
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.parkzumi.parkzumi',
                tileBuilder: dark ? darkModeTileBuilder : null,
              ),
              if (view != null) PolylineLayer(polylines: _kerbs(context, view)),
              if (view != null) MarkerLayer(markers: _markers(context, view)),
              if (location.value case final Located here)
                MarkerLayer(markers: [
                  Marker(point: _ll(here.point), width: 22, height: 22, child: const _YouAreHere()),
                ]),
              const RichAttributionWidget(
                alignment: AttributionAlignment.bottomLeft,
                attributions: [TextSourceAttribution('OpenStreetMap contributors')],
              ),
            ],
          ),
        ),
        Positioned(
          top: topInset + Space.s,
          left: Space.l,
          right: Space.l,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              const Expanded(child: Align(alignment: Alignment.centerLeft, child: ContextChip())),
              const SizedBox(width: Space.s),
              _RoundButton(
                icon: CupertinoIcons.location_fill,
                label: 'Check where I am',
                busy: location.isLoading,
                onTap: () => _locate(openNearest: true),
              ),
            ]),
            const SizedBox(height: Space.s),
            if (shared != null)
              Notice(
                level: Level.info,
                icon: CupertinoIcons.map_fill,
                title: 'From Google Maps: ${shared.title}',
                message: 'Maps shares a name, not coordinates. Pick the spot closest to where you’re going.',
                action: 'Dismiss',
                onAction: () => ref.read(sharedPlaceProvider.notifier).set(null),
              )
            else if (location.value case LocationUnavailable(problem: LocationProblem.notAsked))
              Notice(
                level: Level.info,
                icon: CupertinoIcons.location_fill,
                title: LocationProblem.notAsked.label,
                message: 'Parkzumi uses your location only when you tap. Until then, it shows the $pilotArea pilot area.',
                action: 'Use my location',
                onAction: () => _locate(openNearest: true),
              )
            else if (location.value case LocationUnavailable(:final problem))
              Notice(
                level: Level.unknown,
                icon: CupertinoIcons.location_slash_fill,
                title: problem.label,
                message: 'Pick the exact spot from the list. Results are for the spot you choose.',
                action: problem == LocationProblem.denied ? 'Open settings' : 'Try again',
                onAction: problem == LocationProblem.denied
                    ? () => ref.read(servicesProvider).location.openSettings()
                    : () => _locate(),
              )
            else if (view != null && view.here != null && !view.inPilotArea)
              const Notice(
                level: Level.info,
                icon: CupertinoIcons.map,
                title: 'You’re outside the pilot area',
                message: 'Showing $pilotArea, Mumbai. Plan a visit by changing the time.',
              ),
          ]),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.38,
          minChildSize: 0.14,
          maxChildSize: 0.88,
          snap: true,
          snapSizes: const [0.14, 0.38, 0.88],
          builder: (context, controller) => _SpotList(
            controller: controller,
            view: view,
            selected: _selected,
            onOpen: (id) {
              final spot = view?.snapshot.spot(id);
              if (spot != null) _map.move(_ll(spot.location), 18);
              _open(id);
            },
          ),
        ),
      ]),
    );
  }

  List<Polyline> _kerbs(BuildContext context, AssessmentsView view) => [
        for (final s in view.snapshot.spots.where((s) => s.line.length > 1))
          Polyline(
            points: [for (final p in s.line) _ll(p)],
            strokeWidth: s.id == _selected ? 9 : 7,
            color: VerdictLook.forAssessment(context, view.byspot[s.id]!).fg,
            borderStrokeWidth: 2,
            borderColor: Pz.of(context).surface,
          ),
      ];

  List<Marker> _markers(BuildContext context, AssessmentsView view) => [
        for (final s in view.snapshot.spots)
          Marker(
            point: _ll(s.location),
            width: 48,
            height: 48,
            child: _SpotMarker(
              key: ValueKey('marker-${s.id}'),
              look: VerdictLook.forAssessment(context, view.byspot[s.id]!),
              selected: s.id == _selected,
              label: '${s.name}: ${VerdictLook.forAssessment(context, view.byspot[s.id]!).label}',
              onTap: () => _open(s.id),
            ),
          ),
      ];
}

class _SpotMarker extends StatelessWidget {
  const _SpotMarker({super.key, required this.look, required this.selected, required this.label, required this.onTap});
  final VerdictLook look;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Center(
          child: AnimatedScale(
            scale: selected ? 1.25 : 1,
            duration: Motion.of(context, Motion.standard),
            curve: Motion.curve,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: look.bg,
                shape: BoxShape.circle,
                border: Border.all(color: selected ? pz.textPrimary : look.fg, width: selected ? 2.5 : 2),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Icon(look.icon, size: 17, color: look.fg),
            ),
          ),
        ),
      ),
    );
  }
}

class _YouAreHere extends StatelessWidget {
  const _YouAreHere();

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Your location',
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2F6BFF),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [BoxShadow(color: const Color(0xFF2F6BFF).withValues(alpha: 0.35), blurRadius: 10, spreadRadius: 4)],
          ),
        ),
      );
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.label, required this.onTap, this.busy = false});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: busy
            ? null
            : () {
                HapticFeedback.lightImpact();
                onTap();
              },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Pz.lime,
            shape: BoxShape.circle,
            border: Border.all(color: Pz.ink, width: 1.5),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: busy ? const CupertinoActivityIndicator(color: Pz.ink) : Icon(icon, color: Pz.ink, size: 20),
        ),
      ),
    );
  }
}

class _SpotList extends ConsumerWidget {
  const _SpotList({required this.controller, required this.view, required this.selected, required this.onOpen});
  final ScrollController controller;
  final AssessmentsView? view;
  final String? selected;
  final void Function(String spotId) onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pz = Pz.of(context);
    final t = Theme.of(context).textTheme;
    final v = view;
    final services = ref.watch(servicesProvider);
    final ranked = v == null
        ? const <Assessment>[]
        : [
            ...services.engine.rankAlternatives(v.all, v.distances),
            ...v.all.where((a) => a.verdict == Verdict.prohibited),
          ];
    final ctx = ref.watch(checkContextProvider);

    return Container(
      decoration: BoxDecoration(
        color: pz.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Radii.container)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: CustomScrollView(controller: controller, slivers: [
        SliverToBoxAdapter(
          child: Column(children: [
            const SizedBox(height: Space.s),
            Container(width: 36, height: 5, decoration: BoxDecoration(color: pz.border, borderRadius: BorderRadius.circular(3))),
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.l, Space.m, Space.l, Space.xs),
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(v?.inPilotArea == true ? 'Spots near you' : 'Spots in the pilot area', style: t.headlineSmall),
                    const SizedBox(height: 2),
                    Text(
                      v == null
                          ? 'Loading evidence…'
                          : '$pilotArea · for a ${ctx.vehicle.short}, ${formatDuration(ctx.stay)} · rules v${v.snapshot.version}, saved ${formatAge(DateTime.now().difference(v.fetchedAt))}',
                      style: t.bodyMedium,
                    ),
                  ]),
                ),
              ]),
            ),
          ]),
        ),
        if (v == null)
          const SliverFillRemaining(hasScrollBody: false, child: Center(child: CupertinoActivityIndicator()))
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(Space.l, Space.s, Space.l, MediaQuery.paddingOf(context).bottom + 96),
            sliver: SliverList.separated(
              itemCount: ranked.length,
              separatorBuilder: (_, _) => const SizedBox(height: Space.s),
              itemBuilder: (context, i) {
                final a = ranked[i];
                final spot = v.snapshot.spot(a.request.spotId)!;
                return SpotRow(
                  spot: spot,
                  assessment: a,
                  distance: v.distances[spot.id],
                  selected: spot.id == selected,
                  onTap: () => onOpen(spot.id),
                );
              },
            ),
          ),
      ]),
    );
  }
}

class SpotRow extends StatelessWidget {
  const SpotRow({super.key, required this.spot, required this.assessment, required this.distance, required this.onTap, this.selected = false});
  final Spot spot;
  final Assessment assessment;
  final double? distance;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    final t = Theme.of(context).textTheme;
    final look = VerdictLook.forAssessment(context, assessment);
    final community = assessment.findings.any((f) => f.title == 'Locals have parked here');
    return Semantics(
      button: true,
      label: '${spot.name}. ${look.label}. ${assessment.headline}. ${distanceLabel(distance)} away',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: Motion.of(context, Motion.standard),
          padding: const EdgeInsets.all(Space.m),
          decoration: BoxDecoration(
            color: pz.surface,
            borderRadius: BorderRadius.circular(Radii.card),
            border: Border.all(color: selected ? pz.textPrimary : pz.border, width: selected ? 1.5 : 1),
          ),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: look.bg, borderRadius: BorderRadius.circular(Radii.control)),
              child: Icon(look.icon, color: look.fg, size: 22),
            ),
            const SizedBox(width: Space.m),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(spot.name, style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(assessment.headline, style: t.bodyMedium?.copyWith(color: look.fg, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  Text('${spot.kind.label} · ${distanceLabel(distance)}', style: t.labelSmall?.copyWith(fontFeatures: Fonts.tabular)),
                  if (community) ...[
                    const SizedBox(width: Space.s),
                    Icon(CupertinoIcons.person_2_fill, size: 13, color: pz.community.fg),
                    const SizedBox(width: 3),
                    Text('Locals have parked', style: t.labelSmall?.copyWith(color: pz.community.fg)),
                  ],
                ]),
              ]),
            ),
            Icon(CupertinoIcons.chevron_right, size: 16, color: pz.textSecondary),
          ]),
        ),
      ),
    );
  }
}
