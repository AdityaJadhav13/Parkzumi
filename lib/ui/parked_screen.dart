import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../data/device_db.dart';
import '../data/session_service.dart';
import '../domain/assessment.dart';
import '../domain/models.dart';
import '../domain/time_ist.dart';
import 'widgets.dart';

class ParkedScreen extends ConsumerWidget {
  const ParkedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pz = Pz.of(context);
    final active = ref.watch(activeSessionProvider);
    final history = ref.watch(sessionHistoryProvider).value ?? const [];
    final t = Theme.of(context).textTheme;
    return CupertinoPageScaffold(
      backgroundColor: pz.background,
      child: CustomScrollView(slivers: [
        CupertinoSliverNavigationBar(largeTitle: const Text('Parked'), backgroundColor: pz.background, border: null),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: Space.l),
          sliver: SliverList.list(children: [
            switch (active) {
              AsyncData(value: final s?) => _SessionCard(session: s),
              AsyncData() => EmptyState(
                  title: 'Not parked right now',
                  message: 'Check a spot, then tap Park here. Zumi keeps the details and reminds you before you need to leave.',
                  action: PzButton(
                    label: 'Check a spot',
                    icon: CupertinoIcons.map_fill,
                    expand: false,
                    onPressed: () => ref.read(tabProvider.notifier).go(RiderTab.check),
                  ),
                ),
              _ => const Padding(padding: EdgeInsets.all(Space.x4), child: CupertinoActivityIndicator()),
            },
            if (history.isNotEmpty) ...[
              const SectionHeader('Earlier'),
              for (final s in history.take(8))
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.s),
                  child: PzCard(
                    padding: const EdgeInsets.all(Space.m),
                    child: Row(children: [
                      Icon(vehicleIcon(VehicleClass.values.byName(s.vehicle)), color: pz.textSecondary),
                      const SizedBox(width: Space.m),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(s.spotName, style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('${formatIstDateTime(s.startedAt)} → ${s.endedAt == null ? '—' : formatIstTime(s.endedAt!)}',
                              style: t.bodyMedium?.copyWith(fontFeatures: Fonts.tabular)),
                        ]),
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

class _SessionCard extends ConsumerWidget {
  const _SessionCard({required this.session});
  final Session session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pz = Pz.of(context);
    final t = Theme.of(context).textTheme;
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final s = session;
    final verdict = Verdict.values.byName(s.verdict);
    final look = VerdictLook.of(context, verdict);
    final left = s.deadlineAt.difference(now);
    final overdue = left.isNegative;
    final missing = s.state == SessionState.missing.name;
    final services = ref.watch(servicesProvider);

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      PzCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(vehicleIcon(VehicleClass.values.byName(s.vehicle)), color: pz.textPrimary),
            const SizedBox(width: Space.s),
            Expanded(child: Text(s.spotName, style: t.titleLarge)),
          ]),
          const SizedBox(height: 4),
          Text('Parked ${formatIstDateTime(s.startedAt)} · rules v${s.evidenceVersion}', style: t.bodyMedium?.copyWith(fontFeatures: Fonts.tabular)),
          const SizedBox(height: Space.m),
          StatusPill(look),
          const SizedBox(height: Space.l),
          Text(missing ? 'Vehicle reported missing' : 'Be back by ${formatIstTime(s.deadlineAt)}',
              style: t.displaySmall?.copyWith(fontFeatures: Fonts.tabular, color: overdue && !missing ? pz.restriction.fg : null)),
          if (!missing)
            Text(
              overdue
                  ? '${s.deadlineReason} · ${formatDuration(-left)} ago'
                  : '${s.deadlineReason} · in ${formatDuration(left + const Duration(minutes: 1))}',
              style: t.bodyLarge?.copyWith(fontFeatures: Fonts.tabular),
            ),
        ]),
      ),
      if (s.changeNote != null) ...[
        const SizedBox(height: Space.s),
        Notice(level: Level.caution, icon: CupertinoIcons.bell_fill, title: 'Conditions changed after you parked', message: s.changeNote),
      ],
      if (missing && s.missingStatus != null) ...[
        const SizedBox(height: Space.s),
        Notice(level: Level.caution, title: MissingStatus.values.byName(s.missingStatus!).label, message: 'Recorded on your phone. It isn’t confirmation from the police.'),
      ],
      if (!missing) ...[
        const SizedBox(height: Space.s),
        _ReminderStatus(session: s),
      ],
      const SizedBox(height: Space.l),
      PzButton(
        label: 'Walk back to it',
        icon: CupertinoIcons.location_north_fill,
        onPressed: () => launchUrl(
          Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${s.lat},${s.lng}&travelmode=walking'),
          mode: LaunchMode.externalApplication,
        ),
      ),
      const SizedBox(height: Space.s),
      Row(children: [
        Expanded(
          child: PzButton(
            label: 'I’m back',
            icon: CupertinoIcons.checkmark_alt,
            kind: PzButtonKind.secondary,
            onPressed: () async {
              await services.sessions.end(s.id);
              await HapticFeedback.mediumImpact();
              if (context.mounted) toast(context, 'Session ended. Want to share how it went?', icon: CupertinoIcons.lightbulb_fill);
            },
          ),
        ),
        const SizedBox(width: Space.s),
        Expanded(
          child: PzButton(
            label: 'Can’t find it',
            icon: CupertinoIcons.exclamationmark_triangle_fill,
            kind: PzButtonKind.destructive,
            onPressed: () => Navigator.of(context).push(CupertinoPageRoute<void>(builder: (_) => MissingVehicleScreen(session: s))),
          ),
        ),
      ]),
    ]);
  }
}

class _ReminderStatus extends ConsumerStatefulWidget {
  const _ReminderStatus({required this.session});
  final Session session;

  @override
  ConsumerState<_ReminderStatus> createState() => _ReminderStatusState();
}

class _ReminderStatusState extends ConsumerState<_ReminderStatus> {
  late Future<(Set<int>, bool)> _status = _load();

  Future<(Set<int>, bool)> _load() async {
    final r = ref.read(servicesProvider).reminders;
    return (await r.pendingIds(), await r.exactAllowed());
  }

  @override
  void didUpdateWidget(covariant _ReminderStatus old) {
    super.didUpdateWidget(old);
    if (old.session.deadlineAt != widget.session.deadlineAt) _status = _load();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
    return FutureBuilder(
      future: _status,
      builder: (context, snap) {
        final data = snap.data;
        if (data == null) return const SizedBox.shrink();
        final (pending, exact) = data;
        final mine = {SessionService.reminderId(s.id, 0), SessionService.reminderId(s.id, 1)}.intersection(pending);
        if (!s.deadlineAt.isAfter(DateTime.now())) return const SizedBox.shrink();
        if (mine.isEmpty) {
          return const Notice(
            level: Level.caution,
            icon: CupertinoIcons.bell_slash_fill,
            title: 'No reminder is set',
            message: 'Notifications may be off. Your session is still saved on this phone.',
          );
        }
        return Notice(
          level: exact ? Level.good : Level.unknown,
          icon: CupertinoIcons.bell_fill,
          title: '${mine.length} reminder${mine.length == 1 ? '' : 's'} set for this session',
          message: exact
              ? 'Scheduled on this phone. Delivery depends on your notification settings.'
              : 'Exact alarms are off, so a reminder may arrive a few minutes late.',
          action: exact || !Platform.isAndroid ? null : 'Allow exact alarms',
          onAction: () async {
            await ref.read(servicesProvider).reminders.requestExactAlarms();
            setState(() => _status = _load());
          },
        );
      },
    );
  }
}

/// Missing vehicle: keep "can't find it", "think it was towed" and "confirmed
/// towed" distinct, and point to official channels — Parkzumi sees no records.
class MissingVehicleScreen extends ConsumerWidget {
  const MissingVehicleScreen({super.key, required this.session});
  final Session session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pz = Pz.of(context);
    final t = Theme.of(context).textTheme;
    final live = ref.watch(activeSessionProvider).value;
    final s = live?.id == session.id ? live! : session;
    final current = s.missingStatus == null ? null : MissingStatus.values.byName(s.missingStatus!);
    final services = ref.watch(servicesProvider);

    return CupertinoPageScaffold(
      backgroundColor: pz.background,
      navigationBar: CupertinoNavigationBar(backgroundColor: pz.background, middle: const Text('Can’t find your vehicle'), previousPageTitle: 'Parked'),
      child: SafeArea(
        child: ListView(children: [
          Group(header: 'Where you left it', children: [
            CupertinoListTile(title: Text(s.spotName), subtitle: Text('Parked ${formatIstDateTime(s.startedAt)}')),
            CupertinoListTile(
              title: const Text('Our answer at the time'),
              subtitle: Text('${s.headline} · rules v${s.evidenceVersion}'),
            ),
            CupertinoListTile(
              title: const Text('Go to the exact spot'),
              leading: const Icon(CupertinoIcons.location_north_fill),
              trailing: const CupertinoListTileChevron(),
              onTap: () => launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${s.lat},${s.lng}&travelmode=walking'),
                  mode: LaunchMode.externalApplication),
            ),
          ]),
          Group(
            header: 'What’s happened?',
            footer: 'Saved on your phone with the time. A report here is your record, not a confirmation.',
            children: [
              for (final m in MissingStatus.values)
                CupertinoListTile(
                  title: Text(m.label),
                  trailing: current == m ? Icon(CupertinoIcons.checkmark_alt, color: pz.tint) : null,
                  onTap: () async {
                    await services.sessions.reportMissing(s.id, m);
                    await HapticFeedback.selectionClick();
                    if (m == MissingStatus.found && context.mounted) Navigator.pop(context);
                  },
                ),
            ],
          ),
          Group(
            header: 'Official help',
            footer: 'Parkzumi can’t see towing, challan or police records. These are the official channels.',
            children: [
              _LinkTile(
                icon: CupertinoIcons.car_detailed,
                title: 'Mumbai Traffic Police — towing information',
                url: 'https://trafficpolicemumbai.maharashtra.gov.in/en/initiative/',
              ),
              _LinkTile(
                icon: CupertinoIcons.doc_text,
                title: 'Check or pay an e-challan (Maharashtra)',
                url: 'https://mahatrafficechallan.gov.in/payechallan/ChallanReceipt.htm',
              ),
              _LinkTile(icon: CupertinoIcons.phone_fill, title: 'Theft or emergency: call 112', url: 'tel:112'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(Space.xl),
            child: Text(
              'Keep any receipt you get. Charges depend on the offence and are recoverable under the Motor Vehicles Act — '
              'we don’t estimate them without the actual receipt.',
              style: t.bodyMedium,
            ),
          ),
        ]),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.icon, required this.title, required this.url});
  final IconData icon;
  final String title;
  final String url;

  @override
  Widget build(BuildContext context) => CupertinoListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(CupertinoIcons.arrow_up_right_square, size: 18),
        onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      );
}
