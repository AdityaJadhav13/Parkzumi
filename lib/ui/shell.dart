import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../platform/companion.dart';
import 'check_screen.dart';
import 'more_screen.dart';
import 'parked_screen.dart';
import 'review_screen.dart';
import 'tips_screen.dart';

/// Tabs for the current role, plus routing of outside launches (companion
/// bubble, place shared from Google Maps) straight into the Check flow.
class RootShell extends ConsumerStatefulWidget {
  const RootShell({super.key});

  @override
  ConsumerState<RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<RootShell> {
  final _riderTabs = CupertinoTabController();
  StreamSubscription<LaunchIntent>? _intents;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    final services = ref.read(servicesProvider);
    // Keep the provider in step with taps on the tab bar, so programmatic jumps always fire.
    _riderTabs.addListener(() => ref.read(tabProvider.notifier).go(_riderTabs.index));
    _intents = services.companion.intents.listen(_handle);
    services.companion.initialIntent().then((i) {
      if (i != null) _handle(i);
    });
    _lifecycle = AppLifecycleListener(onResume: () {
      unawaited(services.sync.sync());
      ref.invalidate(companionStatusProvider);
    });
  }

  @override
  void dispose() {
    _intents?.cancel();
    _lifecycle.dispose();
    _riderTabs.dispose();
    super.dispose();
  }

  Future<void> _handle(LaunchIntent intent) async {
    final services = ref.read(servicesProvider);
    await services.db.setKv('role', Role.rider.name);
    ref.read(tabProvider.notifier).go(RiderTab.check);
    switch (intent) {
      case CheckHereIntent():
        await services.log.record('companion.invoked');
        ref.read(checkHereRequestProvider.notifier).fire();
      case SharedPlaceIntent():
        await services.log.record('maps.place_shared', attrs: {'hasLink': intent.link != null});
        ref.read(sharedPlaceProvider.notifier).set(intent);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tabProvider, (_, i) {
      if (_riderTabs.index != i) _riderTabs.index = i;
    });
    final role = ref.watch(roleProvider).value ?? Role.rider;
    final pz = Pz.of(context);
    final parked = ref.watch(activeSessionProvider).value != null;

    CupertinoTabBar bar(List<BottomNavigationBarItem> items) => CupertinoTabBar(
          items: items,
          backgroundColor: pz.background.withValues(alpha: 0.92),
          activeColor: pz.tint,
          inactiveColor: pz.textSecondary,
          border: Border(top: BorderSide(color: pz.border, width: 0.5)),
          height: 56,
        );

    if (role == Role.reviewer) {
      return CupertinoTabScaffold(
        key: const ValueKey('reviewer'),
        tabBar: bar(const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.checkmark_seal_fill), label: 'Review'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.doc_text), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.ellipsis_circle_fill), label: 'More'),
        ]),
        tabBuilder: (_, i) => CupertinoTabView(
          builder: (_) => switch (i) {
            0 => const ReviewScreen(),
            1 => const PublishScreen(),
            _ => const MoreScreen(),
          },
        ),
      );
    }

    return CupertinoTabScaffold(
      key: const ValueKey('rider'),
      controller: _riderTabs,
      tabBar: bar([
        const BottomNavigationBarItem(icon: Icon(CupertinoIcons.map_fill), label: 'Check'),
        BottomNavigationBarItem(
          icon: Badge(isLabelVisible: parked, backgroundColor: Pz.lime, smallSize: 9, child: const Icon(CupertinoIcons.flag_fill)),
          label: 'Parked',
        ),
        const BottomNavigationBarItem(icon: Icon(CupertinoIcons.lightbulb_fill), label: 'Tips'),
        const BottomNavigationBarItem(icon: Icon(CupertinoIcons.ellipsis_circle_fill), label: 'More'),
      ]),
      tabBuilder: (_, i) => CupertinoTabView(
        builder: (_) => switch (i) {
          RiderTab.check => const CheckScreen(),
          RiderTab.parked => const ParkedScreen(),
          RiderTab.tips => const TipsScreen(),
          _ => const MoreScreen(),
        },
      ),
    );
  }
}
