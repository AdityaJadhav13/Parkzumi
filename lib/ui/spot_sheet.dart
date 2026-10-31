import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../domain/assessment.dart';
import '../domain/models.dart';
import '../domain/time_ist.dart';
import 'context_sheet.dart';
import 'photo_check_screen.dart';
import 'tip_form_screen.dart';
import 'widgets.dart';

Future<void> showSpotSheet(BuildContext context, String spotId) => showCupertinoSheet<void>(
  context: context,
  useNestedNavigation: true,
  showDragHandle: true,
  scrollableBuilder: (c, controller) => SpotSheet(spotId: spotId, controller: controller),
);

/// The full answer for one spot: verdict, why, what to do, what's unknown.
class SpotSheet extends ConsumerStatefulWidget {
  const SpotSheet({super.key, required this.spotId, this.controller});
  final String spotId;
  final ScrollController? controller;

  @override
  ConsumerState<SpotSheet> createState() => _SpotSheetState();
}

class _SpotSheetState extends ConsumerState<SpotSheet> {
  var _parking = false;
  final _shownAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final a = ref.read(assessmentsProvider)?.byspot[widget.spotId];
      if (a == null) return;
      ref
          .read(servicesProvider)
          .log
          .record(
            'assessment.shown',
            correlationId: widget.spotId,
            attrs: {
              'verdict': a.verdict.name,
              'fitsStay': a.fitsStay,
              'evidenceVersion': a.evidenceVersion,
              'evidenceIds': a.appliedEvidenceIds,
              'vehicle': a.request.vehicle.name,
              'stayMin': a.request.stay.inMinutes,
              'withPhoto': a.request.photo != null,
              'renderMs': DateTime.now().difference(_shownAt).inMilliseconds,
            },
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final view = ref.watch(assessmentsProvider);
    final a = view?.byspot[widget.spotId];
    final spot = view?.snapshot.spot(widget.spotId);
    final pz = Pz.of(context);
    if (view == null || a == null || spot == null) {
      return ColoredBox(
        color: pz.background,
        child: const Center(child: CupertinoActivityIndicator()),
      );
    }
    final t = Theme.of(context).textTheme;
    final services = ref.watch(servicesProvider);
    final alternatives = !a.fitsStay || a.verdict == Verdict.unknown
        ? services.engine.rankAlternatives(view.all, view.distances, excluding: spot.id).take(3).toList()
        : const <Assessment>[];
    final community = a.inDimension(Dimension.community).where((f) => f.level != Level.unknown).toList();
    final distance = view.distances[spot.id];

    return CupertinoPageScaffold(
      backgroundColor: pz.background,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollView(
              controller: widget.controller,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(Space.l, Space.x3, Space.l, 0),
                  sliver: SliverList.list(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 44),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(spot.name, style: t.headlineSmall),
                            const SizedBox(height: 4),
                            Text(
                              [
                                spot.kind.label,
                                ?spot.side,
                                if (distance != null) '${distanceLabel(distance)} · ${walkMinutes(distance)} min walk',
                              ].join(' · '),
                              style: t.bodyMedium?.copyWith(fontFeatures: Fonts.tabular),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Space.m),
                      const Align(alignment: Alignment.centerLeft, child: ContextChip(onSurface: true)),
                      const SizedBox(height: Space.l),
                      _VerdictCard(assessment: a),
                      if (!a.restrictedAtStart) ...[
                        const SizedBox(height: Space.m),
                        _DeadlineRow(assessment: a),
                      ],
                      for (final b in a.blockers.where((b) => b.title != a.reason)) ...[
                        const SizedBox(height: Space.s),
                        Notice(
                          level: b.dimension == Dimension.restrictions ? Level.blocker : Level.caution,
                          title: b.title,
                          message: b.detail,
                        ),
                      ],
                      if (a.conditions.isNotEmpty) ...[
                        const SectionHeader('Conditions'),
                        PzCard(
                          child: Column(
                            children: [
                              for (final c in a.conditions)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(CupertinoIcons.checkmark_circle, size: 18, color: pz.permitted.fg),
                                      const SizedBox(width: Space.s),
                                      Expanded(child: Text(c, style: t.bodyLarge)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                      if (community.isNotEmpty) ...[
                        const SectionHeader('What riders say'),
                        PzCard(
                          color: pz.community.bg,
                          borderColor: pz.community.bg,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final f in community) _FindingRow(f, tint: pz.community.fg),
                              const SizedBox(height: Space.xs),
                              Text(
                                'Experiences, not permission. Reviewed before they appear here.',
                                style: t.labelSmall?.copyWith(color: pz.community.fg),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SectionHeader('Why'),
                      for (final d in Dimension.values.where((d) => d != Dimension.community))
                        if (a.inDimension(d).isNotEmpty) _DimensionCard(dimension: d, findings: a.inDimension(d).toList()),
                      if (a.unknowns.isNotEmpty) ...[
                        const SectionHeader('What we don’t know'),
                        PzCard(
                          child: Column(
                            children: [
                              for (final u in a.unknowns)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(CupertinoIcons.question_circle, size: 18, color: pz.unknown.fg),
                                      const SizedBox(width: Space.s),
                                      Expanded(child: Text(u, style: t.bodyLarge)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                      const SectionHeader('Check the spot'),
                      _PhotoCard(spot: spot, assessment: a),
                      if (alternatives.isNotEmpty) ...[
                        SectionHeader(a.fitsStay ? 'Also nearby' : 'Better options nearby'),
                        for (final alt in alternatives) ...[
                          _AltRow(
                            assessment: alt,
                            spot: view.snapshot.spot(alt.request.spotId)!,
                            distance: view.distances[alt.request.spotId],
                          ),
                          const SizedBox(height: Space.s),
                        ],
                      ],
                      const SizedBox(height: Space.xl),
                      PzButton(
                        label: a.verdict == Verdict.prohibited ? 'Park here anyway' : 'Park here',
                        icon: CupertinoIcons.flag_fill,
                        kind: a.verdict == Verdict.prohibited ? PzButtonKind.destructive : PzButtonKind.primary,
                        loading: _parking,
                        onPressed: () => _park(spot, a),
                      ),
                      const SizedBox(height: Space.s),
                      Row(
                        children: [
                          Expanded(
                            child: PzButton(
                              label: 'Directions',
                              icon: CupertinoIcons.arrow_turn_up_right,
                              kind: PzButtonKind.secondary,
                              onPressed: () => _directions(spot),
                            ),
                          ),
                          const SizedBox(width: Space.s),
                          Expanded(
                            child: PzButton(
                              label: 'Share a tip',
                              icon: CupertinoIcons.lightbulb,
                              kind: PzButtonKind.secondary,
                              onPressed: () =>
                                  Navigator.of(context).push(CupertinoPageRoute<void>(builder: (_) => TipFormScreen(spotId: spot.id))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Space.l),
                      Text(
                        'Rules v${a.evidenceVersion} · saved ${formatAge(DateTime.now().difference(view.fetchedAt))} · checked ${formatIstTime(a.evaluatedAt)}\n'
                        'Parkzumi explains evidence. It can’t promise a vehicle won’t be towed.',
                        textAlign: TextAlign.center,
                        style: t.labelSmall?.copyWith(fontFeatures: Fonts.tabular),
                      ),
                      SizedBox(height: MediaQuery.paddingOf(context).bottom + Space.xxl),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Pinned, so the sheet can be closed from anywhere in a long answer.
          Positioned(
            top: Space.l,
            right: Space.s,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(48, 48),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: Icon(CupertinoIcons.xmark_circle_fill, size: 32, color: pz.textSecondary, semanticLabel: 'Close'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _park(Spot spot, Assessment a) async {
    if (a.verdict == Verdict.prohibited) {
      final ok = await confirm(
        context,
        title: 'Restriction during your stay',
        message: '${a.reason}\n\nWe’ll still save where you parked and remind you.',
        action: 'Park anyway',
        destructive: true,
      );
      if (!ok) return;
    }
    setState(() => _parking = true);
    final services = ref.read(servicesProvider);
    // Ask once, at the moment the reason is obvious; the OS ignores repeat prompts anyway.
    if (await services.db.getKv('notificationsAsked') == null) {
      await services.db.setKv('notificationsAsked', 'yes');
      await services.reminders.requestPermission();
    }
    await services.sessions.start(assessment: a, spot: spot);
    await HapticFeedback.mediumImpact();
    if (!mounted) return;
    ref.read(tabProvider.notifier).go(RiderTab.parked);
    // The toast lives in the root overlay, so it outlives this sheet.
    toast(context, 'Parked. We’ll remind you before ${formatIstTime(a.deadline)}.', icon: CupertinoIcons.flag_fill);
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> _directions(Spot spot) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${spot.location.lat},${spot.location.lng}&travelmode=driving',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && mounted) {
      await showInfo(context, 'Couldn’t open Maps', 'Install Google Maps or try again.');
    }
  }
}

class _VerdictCard extends StatelessWidget {
  const _VerdictCard({required this.assessment});
  final Assessment assessment;

  @override
  Widget build(BuildContext context) {
    final look = VerdictLook.forAssessment(context, assessment);
    final t = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      label: '${look.label}. ${assessment.headline}. ${assessment.reason}',
      excludeSemantics: true,
      child: AnimatedSwitcher(
        duration: Motion.of(context, Motion.context),
        switchInCurve: Motion.curve,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(scale: Tween(begin: 0.98, end: 1.0).animate(anim), child: child),
        ),
        child: Container(
          key: ValueKey('${assessment.verdict}-${assessment.headline}'),
          width: double.infinity,
          padding: const EdgeInsets.all(Space.l),
          decoration: BoxDecoration(color: look.bg, borderRadius: BorderRadius.circular(Radii.card)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(look.icon, color: look.fg, size: 22),
                  const SizedBox(width: Space.s),
                  Text(
                    look.label.toUpperCase(),
                    style: TextStyle(fontFamily: Fonts.body, fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.6, color: look.fg),
                  ),
                ],
              ),
              const SizedBox(height: Space.s),
              Text(assessment.headline, style: t.headlineSmall?.copyWith(color: look.fg)),
              const SizedBox(height: Space.xs),
              Text(assessment.reason, style: t.bodyLarge?.copyWith(color: look.fg)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeadlineRow extends StatelessWidget {
  const _DeadlineRow({required this.assessment});
  final Assessment assessment;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    final t = Theme.of(context).textTheme;
    final d = assessment.deadline;
    return PzCard(
      padding: const EdgeInsets.symmetric(horizontal: Space.l, vertical: Space.m),
      child: Row(
        children: [
          Icon(CupertinoIcons.timer, color: pz.textPrimary, size: 22),
          const SizedBox(width: Space.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Be back by ${formatIstTime(d)}', style: t.titleMedium?.copyWith(fontFeatures: Fonts.tabular)),
                Text(
                  '${assessment.deadlineReason}${istStartOfDay(d) != istStartOfDay(assessment.request.start) ? ' · ${formatIstDate(d)}' : ''}',
                  style: t.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DimensionCard extends StatelessWidget {
  const _DimensionCard({required this.dimension, required this.findings});
  final Dimension dimension;
  final List<Finding> findings;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.s),
      child: PzCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dimension.label, style: t.labelLarge),
            const SizedBox(height: Space.s),
            for (final f in findings) _FindingRow(f),
          ],
        ),
      ),
    );
  }
}

class _FindingRow extends StatelessWidget {
  const _FindingRow(this.finding, {this.tint});
  final Finding finding;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final look = levelLook(context, finding.level, source: finding.source);
    final url = finding.url;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(look.icon, size: 18, color: tint ?? look.color),
          ),
          const SizedBox(width: Space.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  finding.title,
                  style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w500, color: tint),
                ),
                if (finding.detail != null) Text(finding.detail!, style: t.bodyMedium?.copyWith(color: tint)),
                if (finding.source != null || url != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        if (finding.source != null) SourceTag(finding.source!),
                        if (url != null)
                          CupertinoButton(
                            padding: const EdgeInsets.only(left: Space.s),
                            minimumSize: const Size(44, 28),
                            onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
                            child: Text(
                              'Open source',
                              style: t.labelMedium?.copyWith(color: Pz.of(context).tint, decoration: TextDecoration.underline),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoCard extends ConsumerWidget {
  const _PhotoCard({required this.spot, required this.assessment});
  final Spot spot;
  final Assessment assessment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final pz = Pz.of(context);
    final photo = assessment.request.photo;
    if (photo != null) {
      return PzCard(
        child: Row(
          children: [
            Icon(CupertinoIcons.camera_fill, color: pz.textPrimary),
            const SizedBox(width: Space.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Photo checked', style: t.titleMedium),
                  Text(
                    '${photo.confidentSigns.length} sign(s), ${photo.objects.length} object(s) · ${photo.model} · observations only',
                    style: t.bodyMedium,
                  ),
                ],
              ),
            ),
            CupertinoButton(
              minimumSize: const Size(44, 44),
              onPressed: () => ref.read(photoFindingsProvider.notifier).clear(spot.id),
              child: Text('Remove', style: TextStyle(color: pz.tint)),
            ),
          ],
        ),
      );
    }
    return PzCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No sign? Take a photo.', style: t.titleMedium),
          const SizedBox(height: 2),
          Text(
            'Gemini looks for signs, gates and entrances near where you’d park. It can raise a doubt — it can’t grant permission.',
            style: t.bodyMedium,
          ),
          const SizedBox(height: Space.m),
          PzButton(
            label: 'Check with a photo',
            icon: CupertinoIcons.camera_fill,
            kind: PzButtonKind.secondary,
            onPressed: () async {
              final findings = await Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => PhotoCheckScreen(spot: spot, vehicle: assessment.request.vehicle),
                ),
              );
              if (findings != null) ref.read(photoFindingsProvider.notifier).attach(spot.id, findings);
            },
          ),
        ],
      ),
    );
  }
}

class _AltRow extends StatelessWidget {
  const _AltRow({required this.assessment, required this.spot, required this.distance});
  final Assessment assessment;
  final Spot spot;
  final double? distance;

  @override
  Widget build(BuildContext context) {
    final look = VerdictLook.forAssessment(context, assessment);
    final t = Theme.of(context).textTheme;
    final pz = Pz.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(CupertinoPageRoute<void>(builder: (_) => SpotSheet(spotId: spot.id))),
      child: Container(
        padding: const EdgeInsets.all(Space.m),
        decoration: BoxDecoration(
          color: pz.surface,
          borderRadius: BorderRadius.circular(Radii.card),
          border: Border.all(color: pz.border),
        ),
        child: Row(
          children: [
            Icon(look.icon, color: look.fg),
            const SizedBox(width: Space.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(spot.name, style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${look.label} · ${distanceLabel(distance)}', style: t.bodyMedium?.copyWith(fontFeatures: Fonts.tabular)),
                ],
              ),
            ),
            Icon(CupertinoIcons.chevron_right, size: 16, color: pz.textSecondary),
          ],
        ),
      ),
    );
  }
}
