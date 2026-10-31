import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../app/services.dart';
import '../app/theme.dart';
import '../data/server/parking_service.dart';
import '../domain/assessment.dart';
import '../domain/models.dart';
import '../domain/time_ist.dart';
import 'widgets.dart';

/// Reviewer role (a second person on another phone in production): decides
/// which rider tips become evidence.
class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pz = Pz.of(context);
    final queue = ref.watch(reviewQueueProvider);
    final reviewed = ref.watch(reviewedProvider).value ?? const [];
    final spots = {for (final s in ref.watch(evidenceProvider).value?.snapshot.spots ?? const <Spot>[]) s.id: s};

    return CupertinoPageScaffold(
      backgroundColor: pz.background,
      child: CustomScrollView(slivers: [
        CupertinoSliverNavigationBar(largeTitle: const Text('Review queue'), backgroundColor: pz.background, border: null),
        CupertinoSliverRefreshControl(onRefresh: () async {
          ref.invalidate(reviewQueueProvider);
          ref.invalidate(reviewedProvider);
          await ref.read(reviewQueueProvider.future);
        }),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: Space.l),
          sliver: SliverList.list(children: [
            const Notice(
              level: Level.info,
              icon: CupertinoIcons.person_crop_circle_badge_checkmark,
              title: 'You’re reviewing as Zumi desk',
              message: 'Accepted tips become rider experiences on that place. They never turn a spot into “Permitted”.',
            ),
            switch (queue) {
              AsyncData(:final value) when value.isEmpty =>
                const EmptyState(title: 'Queue is clear', message: 'New tips from riders appear here once they reach the server.'),
              AsyncData(:final value) => Column(children: [
                  const SectionHeader('Waiting'),
                  for (final item in value) ...[
                    _ReviewCard(item: item, spotName: spots[item.observation.spotId]?.name ?? item.observation.spotId),
                    const SizedBox(height: Space.m),
                  ],
                ]),
              AsyncError(:final error) => Notice(level: Level.blocker, title: 'Couldn’t load the queue', message: '$error'),
              _ => const Padding(padding: EdgeInsets.all(Space.x4), child: CupertinoActivityIndicator()),
            },
            if (reviewed.isNotEmpty) ...[
              const SectionHeader('Recently reviewed'),
              for (final r in reviewed.take(10))
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.s),
                  child: PzCard(
                    padding: const EdgeInsets.all(Space.m),
                    child: Row(children: [
                      Icon(
                        r.status == TipStatus.accepted ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.xmark_circle_fill,
                        color: r.status == TipStatus.accepted ? pz.permitted.fg : pz.restriction.fg,
                      ),
                      const SizedBox(width: Space.m),
                      Expanded(
                        child: Text('${spots[r.observation.spotId]?.name ?? r.observation.spotId} · ${r.observation.outcome.label}',
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                  ),
                ),
            ],
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 80),
          ]),
        ),
      ]),
    );
  }
}

class _ReviewCard extends ConsumerStatefulWidget {
  const _ReviewCard({required this.item, required this.spotName});
  final ReviewItem item;
  final String spotName;

  @override
  ConsumerState<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends ConsumerState<_ReviewCard> {
  var _busy = false;

  Future<void> _decide({required bool accept}) async {
    String? note;
    if (!accept) {
      note = await _askReason();
      if (note == null || note.trim().isEmpty) return;
    }
    setState(() => _busy = true);
    final services = ref.read(servicesProvider);
    try {
      final state = await services.server.reviewTip(
        tipId: widget.item.tipId,
        expectedVersion: widget.item.version,
        accept: accept,
        reviewerId: AppServices.reviewerId,
        note: note,
      );
      await HapticFeedback.mediumImpact();
      if (mounted) {
        toast(context, accept ? 'Accepted · +${state.points} points for the rider' : 'Marked not accepted · rider will see why');
      }
    } on StaleVersion catch (e) {
      if (mounted) await showInfo(context, 'Already reviewed', e.message);
    } on ServiceException catch (e) {
      if (mounted) await showInfo(context, 'Couldn’t save the review', e.message);
    } finally {
      ref.invalidate(reviewQueueProvider);
      ref.invalidate(reviewedProvider);
      ref.invalidate(serverEvidenceProvider);
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<String?> _askReason() {
    final controller = TextEditingController();
    return showCupertinoDialog<String>(
      context: context,
      builder: (c) => CupertinoAlertDialog(
        title: const Text('Why not accept it?'),
        content: Padding(
          padding: const EdgeInsets.only(top: Space.m),
          child: CupertinoTextField(controller: controller, placeholder: 'The rider will see this', autofocus: true, maxLength: 140),
        ),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.pop(c, controller.text), child: const Text('Not accepted')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final o = widget.item.observation;
    final photo = widget.item.photoPath;
    return PzCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.spotName, style: t.titleMedium),
        const SizedBox(height: 2),
        Text('${o.outcome.label} · ${o.vehicle.label} · stayed ${formatDuration(Duration(minutes: o.stayMinutes))}', style: t.bodyLarge),
        const SizedBox(height: 4),
        Text('Happened ${formatIstDateTime(o.eventTime)} · sent ${formatIstDateTime(o.submittedAt)}',
            style: t.labelSmall?.copyWith(fontFeatures: Fonts.tabular)),
        if (o.leftPremises != Tri.unknown || o.staffCheck != StaffCheck.unknown)
          Text(
            [
              if (o.leftPremises == Tri.yes) 'Left the premises',
              if (o.leftPremises == Tri.no) 'Stayed on the premises',
              if (o.staffCheck != StaffCheck.unknown) o.staffCheck.label,
            ].join(' · '),
            style: t.bodyMedium,
          ),
        if (o.note != null) ...[
          const SizedBox(height: Space.s),
          Text('“${o.note}”', style: t.bodyLarge?.copyWith(fontStyle: FontStyle.italic)),
        ],
        if (photo != null && File(photo).existsSync()) ...[
          const SizedBox(height: Space.s),
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.control),
            child: Image.file(File(photo), height: 160, width: double.infinity, fit: BoxFit.cover, semanticLabel: 'Rider’s photo'),
          ),
        ],
        const SizedBox(height: Space.xs),
        Text('From ${widget.item.authorId.split('-').last} · version ${widget.item.version}', style: t.labelSmall),
        const SizedBox(height: Space.m),
        Row(children: [
          Expanded(
            child: PzButton(label: 'Not accepted', kind: PzButtonKind.secondary, onPressed: _busy ? null : () => _decide(accept: false)),
          ),
          const SizedBox(width: Space.s),
          Expanded(
            child: PzButton(label: 'Accept', icon: CupertinoIcons.checkmark_alt, loading: _busy, onPressed: () => _decide(accept: true)),
          ),
        ]),
      ]),
    );
  }
}

/// Reviewer publishes a temporary order (procession, roadworks). Riders with an
/// active session there get the change on their next sync.
class PublishScreen extends ConsumerStatefulWidget {
  const PublishScreen({super.key});

  @override
  ConsumerState<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends ConsumerState<PublishScreen> {
  String? _spotId;
  final _summary = TextEditingController(text: 'Temporary order: no parking (procession)');
  DateTime _from = _roundedNow();
  late DateTime _until = _from.add(const Duration(hours: 4));
  var _editing = 0; // 0 none, 1 from, 2 until
  var _busy = false;

  static DateTime _roundedNow() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day, n.hour, n.minute - n.minute % 15);
  }

  @override
  void dispose() {
    _summary.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final spotId = _spotId;
    if (spotId == null) return;
    setState(() => _busy = true);
    try {
      final version = await ref.read(servicesProvider).server.publishTemporaryOrder(
            TemporaryOrderInput(spotId: spotId, summary: _summary.text.trim(), from: _from, until: _until),
            reviewerId: AppServices.reviewerId,
          );
      await HapticFeedback.mediumImpact();
      if (mounted) toast(context, 'Published as rules v$version. Riders get it on their next sync.');
      ref.invalidate(serverEvidenceProvider);
    } on ServiceException catch (e) {
      if (mounted) await showInfo(context, 'Couldn’t publish', e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    final evidence = ref.watch(serverEvidenceProvider).value;
    final spots = evidence?.spots ?? const <Spot>[];
    final now = DateTime.now();
    final active = (evidence?.rules ?? const <ParkingRule>[])
        .where((r) => r.temporary && (r.effectiveUntil == null || r.effectiveUntil!.isAfter(now)))
        .toList();

    return CupertinoPageScaffold(
      backgroundColor: pz.background,
      child: CustomScrollView(slivers: [
        CupertinoSliverNavigationBar(largeTitle: const Text('Temporary orders'), backgroundColor: pz.background, border: null),
        SliverList.list(children: [
          Group(header: 'New order', footer: 'Demo: stands in for an official notification entered by a reviewer.', children: [
            CupertinoListTile(
              title: const Text('Place'),
              additionalInfo: Text(spots.where((s) => s.id == _spotId).firstOrNull?.name ?? 'Choose', maxLines: 1),
              trailing: const CupertinoListTileChevron(),
              onTap: () async {
                final id = await showCupertinoModalPopup<String>(
                  context: context,
                  builder: (c) => CupertinoActionSheet(
                    actions: [for (final s in spots) CupertinoActionSheetAction(onPressed: () => Navigator.pop(c, s.id), child: Text(s.name))],
                    cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
                  ),
                );
                if (id != null) setState(() => _spotId = id);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(Space.s),
              child: CupertinoTextField(controller: _summary, decoration: const BoxDecoration(), maxLength: 90),
            ),
            CupertinoListTile(
              title: const Text('From'),
              additionalInfo: Text(formatIstDateTime(_from)),
              onTap: () => setState(() => _editing = _editing == 1 ? 0 : 1),
            ),
            if (_editing == 1)
              SizedBox(
                height: 170,
                child: CupertinoDatePicker(initialDateTime: _from, minuteInterval: 15, onDateTimeChanged: (d) => setState(() => _from = d)),
              ),
            CupertinoListTile(
              title: const Text('Until'),
              additionalInfo: Text(formatIstDateTime(_until)),
              onTap: () => setState(() => _editing = _editing == 2 ? 0 : 2),
            ),
            if (_editing == 2)
              SizedBox(
                height: 170,
                child: CupertinoDatePicker(initialDateTime: _until, minuteInterval: 15, onDateTimeChanged: (d) => setState(() => _until = d)),
              ),
          ]),
          Padding(
            padding: const EdgeInsets.all(Space.l),
            child: PzButton(label: 'Publish order', loading: _busy, onPressed: _spotId == null ? null : _publish),
          ),
          if (active.isNotEmpty)
            Group(header: 'In force or upcoming', children: [
              for (final r in active)
                CupertinoListTile(
                  title: Text(r.summary, maxLines: 2),
                  subtitle: Text('${spots.where((s) => r.spotIds.contains(s.id)).firstOrNull?.name ?? ''} · until ${formatIstDateTime(r.effectiveUntil!)}'),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await ref.read(servicesProvider).server.withdrawRule(r.id, reviewerId: AppServices.reviewerId);
                      ref.invalidate(serverEvidenceProvider);
                    },
                    child: const Text('Withdraw'),
                  ),
                ),
            ]),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 80),
        ]),
      ]),
    );
  }
}
