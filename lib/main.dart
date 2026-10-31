import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:measure_flutter/measure_flutter.dart';

import 'app/app.dart';
import 'app/measure_bridge.dart';
import 'app/providers.dart';
import 'app/services.dart';

Future<void> main() async {
  final startup = Stopwatch()..start();
  WidgetsFlutterBinding.ensureInitialized();
  final AppServices services;
  try {
    services = await AppServices.start();
  } catch (e) {
    runApp(StartupErrorApp(error: e));
    return;
  }
  services.startSyncLoop();
  final app = ProviderScope(
    overrides: [servicesProvider.overrideWithValue(services)],
    child: const ParkzumiApp(),
  );
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => services.log.record('app.first_frame', attrs: {'ms': startup.elapsedMilliseconds}),
  );
  if (MeasureBridge.enabled) {
    services.log.forward = MeasureBridge.forward;
    await Measure.instance.init(
      () => runApp(MeasureWidget(child: app)),
      config: const MeasureConfig(enableLogging: kDebugMode),
    );
  } else {
    runApp(app);
  }
}
