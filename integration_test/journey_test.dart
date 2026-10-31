
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parkzumi/app/providers.dart';
import 'package:parkzumi/domain/time_ist.dart';
import 'package:parkzumi/main.dart' as app;
import 'package:parkzumi/ui/diagnostics_screen.dart';
import 'package:parkzumi/ui/shell.dart';
import 'package:parkzumi/ui/spot_sheet.dart';
import 'package:parkzumi/ui/tip_form_screen.dart';

/// The full rider journey on a real device or simulator, including the
/// headline recovery case: the server saves a tip but the reply is lost; the
/// app retries with the same operation id and nothing is duplicated.
///
/// Run: `flutter drive --driver=test_driver/integration_test.dart --target=integration_test/journey_test.dart -d DEVICE`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// scripts/journey.sh captures the device screen when it sees this line
  /// (in-app capture is unreliable on iOS after a sheet has been dismissed).
  Future<void> shot(WidgetTester t, String name) async {
    for (var i = 0; i < 6; i++) {
      await t.pump(const Duration(milliseconds: 150));
    }
    debugPrint('PZSHOT $name');
    for (var i = 0; i < 14; i++) {
      await t.pump(const Duration(milliseconds: 150));
    }
  }

  Future<void> pumpUntil(WidgetTester t, Finder f, {Duration timeout = const Duration(seconds: 25)}) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await t.pump(const Duration(milliseconds: 200));
      if (f.evaluate().isNotEmpty) return;
    }
    throw TestFailure('Timed out waiting for $f');
  }

  Future<void> tap(WidgetTester t, Finder f) async {
    await pumpUntil(t, f);
    await t.ensureVisible(f.first);
    await t.pump(const Duration(milliseconds: 250));
    await t.tap(f.first, warnIfMissed: false);
    await t.pump(const Duration(milliseconds: 500));
  }

  Future<void> tab(WidgetTester t, String label) => tap(t, find.descendant(of: find.byType(CupertinoTabBar), matching: find.text(label)));

  /// Opens a spot from its map marker (the list below is lazily built and snaps).
  Future<void> tapSpot(WidgetTester t, String spotId) => tap(t, find.byKey(ValueKey('marker-$spotId')));

  /// Scrolls inside [screen] until [f] is built (lists are lazy), then returns.
  Future<void> reveal(WidgetTester t, Type screen, Finder f) async {
    final scrollable = find.descendant(of: find.byType(screen), matching: find.byType(Scrollable)).first;
    await pumpUntil(t, scrollable);
    if (f.evaluate().isEmpty) await t.scrollUntilVisible(f, 300, scrollable: scrollable, maxScrolls: 30);
  }

  testWidgets('rider journey with a lost reply and a review', (t) async {
    await app.main();
    await pumpUntil(t, find.byType(RootShell));
    final container = ProviderScope.containerOf(t.element(find.byType(RootShell)));
    final services = container.read(servicesProvider);
    await services.resetDemo();
    await services.db.setKv('notificationsAsked', 'yes');
    await services.db.setKv('role', 'rider');

    // 1. Check: the pilot area with every spot judged for a bike, 2 h, now.
    await pumpUntil(t, find.text('Two-wheeler bay, Ram Mandir Rd (sample)'));
    await t.pump(const Duration(seconds: 2));
    await shot(t, '01_check');

    // 2. The odd–even road side that isn't today's parking side.
    final oddToday = istWall(DateTime.now()).day.isOdd;
    final restrictedSide = oddToday ? 'somani-w' : 'somani-e';
    await tapSpot(t, restrictedSide);
    await pumpUntil(t, find.text('Don’t park here'));
    await t.pump(const Duration(seconds: 1));
    await shot(t, '02_spot_restriction');
    await tap(t, find.byIcon(CupertinoIcons.xmark_circle_fill));

    // 3. A reviewed bay with no conditions — the only plain "Permitted" — then park.
    await tapSpot(t, 'bike-bay');
    await pumpUntil(t, find.text('Parking permitted for your stay'));
    await t.pump(const Duration(seconds: 1));
    await shot(t, '03_spot_permitted');
    await reveal(t, SpotSheet, find.text('Park here'));
    await tap(t, find.text('Park here'));
    await pumpUntil(t, find.textContaining('Be back by'));
    await t.pump(const Duration(seconds: 1));
    await shot(t, '04_parked');

    // 4. Arm the fault: the server will save the next tip but the reply is lost.
    await tab(t, 'More');
    await tap(t, find.text('Diagnostics & failure demo'));
    await tap(t, find.descendant(
      of: find.widgetWithText(CupertinoListTile, 'Lose the reply to the next tip'),
      matching: find.byType(CupertinoSwitch),
    ));
    await tap(t, find.text('More').first);

    // 5. Share a tip about the bank compound.
    await tab(t, 'Check');
    await tapSpot(t, 'bank-compound');
    await reveal(t, SpotSheet, find.text('What riders say'));
    await t.pump(const Duration(seconds: 1));
    await shot(t, '05_spot_community');
    await reveal(t, SpotSheet, find.text('Share a tip'));
    await tap(t, find.text('Share a tip'));
    await reveal(t, TipFormScreen, find.text('Send tip'));
    await tap(t, find.text('Send tip'));

    // 6. The server saved it, the reply was lost — and then connectivity drops.
    final end = DateTime.now().add(const Duration(seconds: 15));
    while (DateTime.now().isBefore(end)) {
      await t.pump(const Duration(milliseconds: 100));
      final lost = await (services.db.select(services.db.eventLog)..where((e) => e.type.equals('network.response_lost'))).get();
      if (lost.isNotEmpty) break;
    }
    services.net.update((n) => n.online = false);
    await tap(t, find.byIcon(CupertinoIcons.xmark_circle_fill));
    await tab(t, 'Tips');
    await pumpUntil(t, find.textContaining('waiting to send'));
    await shot(t, '06_tip_waiting');

    // Back online: the retry (same operation id) is recognised by the server.
    services.net.update((n) => n.online = true);
    await pumpUntil(t, find.text('Waiting for review'), timeout: const Duration(seconds: 45));
    await shot(t, '07_tip_received');
    expect((await services.serverDb.select(services.serverDb.srvTips).get()).length, 1);

    // 7. The diagnostics trail shows what happened.
    await tab(t, 'More');
    await tap(t, find.text('Diagnostics & failure demo'));
    await reveal(t, DiagnosticsScreen, find.text('server.duplicate_ignored'));
    await shot(t, '08_diagnostics');
    await tap(t, find.text('More').first);

    // 8. A reviewer accepts it; the rider sees the outcome and one reward.
    await tap(t, find.text('Reviewer'));
    await pumpUntil(t, find.text('Accept'));
    await shot(t, '09_review_queue');
    await tap(t, find.text('Accept'));
    await t.pump(const Duration(seconds: 1));
    await tab(t, 'More');
    await tap(t, find.text('Rider'));
    await services.sync.sync();
    await tab(t, 'Tips');
    await pumpUntil(t, find.textContaining('+10 points'));
    await shot(t, '10_tip_accepted');
    expect((await services.serverDb.select(services.serverDb.srvRewards).get()).length, 1);
  });
}
