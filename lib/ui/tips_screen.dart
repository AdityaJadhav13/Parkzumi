import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../data/device_db.dart';
import '../data/server/parking_service.dart';
import '../data/tips_service.dart';
import '../domain/assessment.dart';
import '../domain/models.dart';
import '../domain/time_ist.dart';
import 'tip_form_screen.dart';
import 'widgets.dart';

class TipsScreen extends ConsumerWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pz = Pz.of(context);
    final t = Theme.of(context).textTheme;
    final tips = ref.watch(tipsProvider).value ?? const <Tip>[];
    final ops = ref.watch(outboxProvider).value ?? const <OutboxOp>[];
    final points = ref.watch(pointsProvider).value ?? 0;
    final spots = {for (final s in ref.watch(evidenceProvider).value?.snapshot.spots ?? const <Spot>[]) s.id: s};
    final waiting = ops.where((o) => o.state == OpState.pending || o.state == OpState.inFlight).toList();
    final accepted = tips.where((t) => t.status == TipStatus.accepted.name).length;

    return CupertinoPageScaffold(
      backgroundColor: pz.background,
      child: CustomScrollView(slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: const Text('Tips'),
          backgroundColor: pz.background,
          border: null,
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size(44, 44),
            onPressed: () => Navigator.of(context).push(CupertinoPageRoute<void>(builder: (_) => const TipFormScreen())),
            child: const Icon(CupertinoIcons.add_circled_solid, size: 28, semanticLabel: 'Share a tip'),
          ),
        ),
        CupertinoSliverRefreshControl(onRefresh: () => ref.read(servicesProvider).sync.retryNow()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: Space.l),
          sliver: SliverList.list(children: [
            PzCard(
              color: pz.community.bg,
              borderColor: pz.community.bg,
              child: Row(children: [
                const Zumi(size: 52),
                const SizedBox(width: Space.m),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('$points points', style: t.headlineSmall?.copyWith(color: pz.community.fg, fontFeatures: Fonts.tabular)),
                    Text('$accepted accepted · points come from useful, reviewed tips — not from how many you send.',
                        style: t.bodyMedium?.copyWith(color: pz.community.fg)),
                  ]),
                ),
              ]),
            ),
            if (waiting.isNotEmpty) ...[
              const SizedBox(height: Space.s),
              Notice(
                level: Level.unknown,
                icon: CupertinoIcons.tray_arrow_up_fill,
                title: '${waiting.length} step${waiting.length == 1 ? '' : 's'} waiting to send',
                message: _waitingMessage(waiting),
                action: 'Retry now',
                onAction: () => ref.read(servicesProvider).sync.retryNow(),
              ),
            ],
            if (tips.isEmpty)
              const EmptyState(
                title: 'No tips yet',
                message: 'Parked somewhere useful — or got turned away? Tell the next rider what happened.',
              )
            else ...[
              const SectionHeader('Your tips'),
              for (final tip in tips) ...[
                _TipCard(tip: tip, spotName: spots[tip.spotId]?.name ?? tip.spotId),
                const SizedBox(height: Space.s),
              ],
            ],
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 80),
          ]),
        ),
      ]),
    );
  }

  static String _waitingMessage(List<OutboxOp> ops) {
    final next = ops.map((o) => o.nextAttemptAt).reduce((a, b) => a.isBefore(b) ? a : b);
    final wait = next.difference(DateTime.now());
    final error = ops.map((o) => o.lastError).whereType<String>().firstOrNull;
    return [
      'Saved on your phone.',
      if (error != null) 'Last try: ${error.split(': ').last}.',
      wait.inSeconds > 0 ? 'Next try in ${wait.inSeconds} s.' : 'Sending…',
    ].join(' ');
  }
}

class _TipCard extends ConsumerWidget {
  const _TipCard({required this.tip, required this.spotName});
  final Tip tip;
  final String spotName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pz = Pz.of(context);
    final t = Theme.of(context).textTheme;
    final status = TipStatus.values.byName(tip.status);
    final obs = Observation.fromJson(asJson(jsonDecode(tip.payload)));
    final (fg, bg, icon) = switch (status) {
      TipStatus.queued => (pz.unknown.fg, pz.unknown.bg, CupertinoIcons.tray_arrow_up_fill),
      TipStatus.sending => (pz.unknown.fg, pz.unknown.bg, CupertinoIcons.paperplane_fill),
      TipStatus.received => (pz.caution.fg, pz.caution.bg, CupertinoIcons.hourglass),
      TipStatus.accepted => (pz.permitted.fg, pz.permitted.bg, CupertinoIcons.checkmark_seal_fill),
      TipStatus.rejected => (pz.restriction.fg, pz.restriction.bg, CupertinoIcons.xmark_circle_fill),
      TipStatus.failed => (pz.restriction.fg, pz.restriction.bg, CupertinoIcons.exclamationmark_circle_fill),
    };
    final step = switch (status) {
      TipStatus.queued || TipStatus.sending || TipStatus.failed => 0,
      TipStatus.received => 1,
      TipStatus.accepted || TipStatus.rejected => 2,
    };

    return PzCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(spotName, style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
          StatusPill(VerdictLook(fg, bg, icon, status.label), compact: true),
        ]),
        const SizedBox(height: 4),
        Text('${obs.outcome.label} · ${obs.vehicle.label} · ${formatDuration(Duration(minutes: obs.stayMinutes))}', style: t.bodyLarge),
        Text('Happened ${formatIstDateTime(obs.eventTime)} · sent ${formatIstDateTime(obs.submittedAt)}',
            style: t.labelSmall?.copyWith(fontFeatures: Fonts.tabular)),
        const SizedBox(height: Space.m),
        _Steps(step: step, failed: status == TipStatus.failed || status == TipStatus.rejected),
        if (tip.reviewNote != null) ...[
          const SizedBox(height: Space.s),
          Text('Reviewer: “${tip.reviewNote}”', style: t.bodyMedium),
        ],
        if (status == TipStatus.accepted && tip.points > 0) ...[
          const SizedBox(height: Space.s),
          Text('Good tip. That helps the next rider. +${tip.points} points', style: t.bodyMedium?.copyWith(color: pz.permitted.fg)),
        ],
        if (status == TipStatus.failed) ...[
          const SizedBox(height: Space.s),
          Text(tip.failure ?? 'Couldn’t send', style: t.bodyMedium?.copyWith(color: pz.restriction.fg)),
          PzButton(
            label: 'Discard',
            kind: PzButtonKind.plain,
            expand: false,
            onPressed: () => ref.read(servicesProvider).tips.discard(tip.id),
          ),
        ],
      ]),
    );
  }
}

class _Steps extends StatelessWidget {
  const _Steps({required this.step, required this.failed});
  final int step;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    const labels = ['Saved', 'Received', 'Reviewed'];
    return Row(children: [
      for (var i = 0; i < labels.length; i++) ...[
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AnimatedContainer(
              duration: Motion.of(context, Motion.context),
              height: 4,
              decoration: BoxDecoration(
                color: i <= step ? (failed && i == step ? pz.restriction.fg : pz.textPrimary) : pz.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),
            Text(labels[i], style: Theme.of(context).textTheme.labelSmall),
          ]),
        ),
        if (i < labels.length - 1) const SizedBox(width: Space.xs),
      ],
    ]);
  }
}
