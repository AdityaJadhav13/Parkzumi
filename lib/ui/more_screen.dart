import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../data/pilot_seed.dart';
import '../platform/companion.dart';
import 'diagnostics_screen.dart';
import 'widgets.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pz = Pz.of(context);
    final role = ref.watch(roleProvider).value ?? Role.rider;
    final walk = ref.watch(walkBackProvider).value ?? 10;
    final services = ref.watch(servicesProvider);

    return CupertinoPageScaffold(
      backgroundColor: pz.background,
      child: CustomScrollView(slivers: [
        CupertinoSliverNavigationBar(largeTitle: const Text('More'), backgroundColor: pz.background, border: null),
        SliverList.list(children: [
          Group(
            header: 'Using Parkzumi as',
            footer: 'Reviewer mode stands in for a second person — a community reviewer on another phone.',
            children: [
              Padding(
                padding: const EdgeInsets.all(Space.m),
                child: CupertinoSlidingSegmentedControl<Role>(
                  groupValue: role,
                  children: const {
                    Role.rider: Padding(padding: EdgeInsets.all(8), child: Text('Rider')),
                    Role.reviewer: Padding(padding: EdgeInsets.all(8), child: Text('Reviewer')),
                  },
                  onValueChanged: (r) async {
                    if (r == null) return;
                    await HapticFeedback.selectionClick();
                    await services.db.setKv('role', r.name);
                    await services.log.record('role.switched', attrs: {'to': r.name});
                  },
                ),
              ),
            ],
          ),
          Group(header: 'Reminders', children: [
            CupertinoListTile(
              title: const Text('Walk back to your vehicle'),
              additionalInfo: Text('$walk min', style: const TextStyle(fontFeatures: Fonts.tabular)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(44, 44),
                  onPressed: walk > 0 ? () => services.db.setKv('walkBack', '${walk - 5}') : null,
                  child: const Icon(CupertinoIcons.minus_circle, semanticLabel: 'Less'),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(44, 44),
                  onPressed: walk < 60 ? () => services.db.setKv('walkBack', '${walk + 5}') : null,
                  child: const Icon(CupertinoIcons.plus_circle, semanticLabel: 'More'),
                ),
              ]),
            ),
          ]),
          const _CompanionGroup(),
          Group(header: 'Prototype', children: [
            CupertinoListTile(
              leading: const Icon(CupertinoIcons.waveform_path_ecg),
              title: const Text('Diagnostics & failure demo'),
              trailing: const CupertinoListTileChevron(),
              onTap: () => Navigator.of(context).push(CupertinoPageRoute<void>(builder: (_) => const DiagnosticsScreen())),
            ),
            CupertinoListTile(
              leading: const Icon(CupertinoIcons.doc_text_search),
              title: const Text('Data sources & limits'),
              trailing: const CupertinoListTileChevron(),
              onTap: () => showInfo(context, 'Data sources & limits', _limits),
            ),
            CupertinoListTile(
              leading: Icon(CupertinoIcons.arrow_clockwise, color: pz.restriction.fg),
              title: Text('Reset demo data', style: TextStyle(color: pz.restriction.fg)),
              onTap: () async {
                final ok = await confirm(context,
                    title: 'Reset demo data?',
                    message: 'Deletes tips, sessions, the event log and the simulated server, then reloads the pilot data.',
                    action: 'Reset',
                    destructive: true);
                if (!ok) return;
                await services.resetDemo();
                ref.invalidate(photoFindingsProvider);
                if (context.mounted) toast(context, 'Demo data reset');
              },
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(Space.xl),
            child: Column(children: [
              const Zumi(size: 48),
              const SizedBox(height: Space.s),
              Text('parkzumi · Know the spot.', style: Theme.of(context).textTheme.labelMedium),
              Text('Pilot: $pilotArea', style: Theme.of(context).textTheme.labelSmall),
            ]),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 80),
        ]),
      ]),
    );
  }

  static const _limits = '''
Real: Mumbai Traffic Police Permanent Notification No. 64/2026 — odd–even parking on Somani Gram Road (checked 31 Oct 2026). Road geometry is approximate.

Sample (labelled in the app): every other place, policy, price and rider report.

Simulated: the server runs inside the app with its own database. Idempotency, review and versioning are real; transport, sign-in and multi-user access are not.

Not promised: whether a vehicle will be towed, live space availability, or delivery of reminders on time.''';
}

class _CompanionGroup extends ConsumerWidget {
  const _CompanionGroup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(companionStatusProvider).value ?? CompanionStatus.unsupported;
    final companion = ref.watch(servicesProvider).companion;
    if (status == CompanionStatus.unsupported) {
      return const Group(
        header: 'Companion',
        footer: 'The floating companion is Android-only. On iPhone, open Parkzumi from the home screen.',
        children: [CupertinoListTile(title: Text('Not available on this device'))],
      );
    }
    return Group(
      header: 'Companion',
      footer: 'A small Zumi bubble floats over other apps — like Google Maps. Tap it to check where you are. It never reads the screen.',
      children: [
        CupertinoListTile(
          leading: const Icon(CupertinoIcons.square_on_square),
          title: const Text('Floating Zumi'),
          subtitle: Text(switch (status) {
            CompanionStatus.needsPermission => 'Needs “Display over other apps”',
            CompanionStatus.on => 'On · tap the bubble anytime',
            _ => 'Off',
          }),
          trailing: CupertinoSwitch(
            value: status == CompanionStatus.on,
            onChanged: (on) async {
              if (status == CompanionStatus.needsPermission) {
                final ok = await confirm(context,
                    title: 'Allow the floating bubble?',
                    message: 'Android asks for “Display over other apps”. Parkzumi only draws its own bubble; it can’t see what’s on screen.',
                    action: 'Open settings');
                if (ok) await companion.requestPermission();
              } else if (on) {
                await companion.start();
              } else {
                await companion.stop();
              }
              ref.invalidate(companionStatusProvider);
            },
          ),
        ),
      ],
    );
  }
}
