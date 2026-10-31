import 'package:flutter/material.dart';

import '../ui/shell.dart';
import 'theme.dart';

class ParkzumiApp extends StatelessWidget {
  const ParkzumiApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Parkzumi',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        // Cupertino routes have no Material ancestor; give every route the body style.
        builder: (context, child) => DefaultTextStyle(style: Theme.of(context).textTheme.bodyLarge!, child: child!),
        home: const RootShell(),
      );
}

/// Shown only if local storage can't be opened at launch.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key, required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: buildTheme(Brightness.light),
        home: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Space.xxl),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Parkzumi couldn’t open its data on this phone.', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                const SizedBox(height: Space.m),
                Text('$error', textAlign: TextAlign.center),
              ]),
            ),
          ),
        ),
      );
}
