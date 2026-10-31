import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

/// How the app was invoked from outside: the floating companion bubble, a
/// place shared from Google Maps, or a normal launch.
sealed class LaunchIntent {
  const LaunchIntent();
}

final class CheckHereIntent extends LaunchIntent {
  const CheckHereIntent();
}

/// Google Maps shares a place as text (name, address, short link). It does not
/// share coordinates, so this is a destination name — never the rider's
/// position and never a parking entrance.
final class SharedPlaceIntent extends LaunchIntent {
  const SharedPlaceIntent(this.text);
  final String text;

  String get title => text
      .replaceAll(RegExp(r'https?://\S+'), '')
      .replaceAll(r'\n', '\n')
      .split('\n')
      .map((l) => l.trim())
      .firstWhere((l) => l.isNotEmpty, orElse: () => 'Shared place');
  String? get link {
    final m = RegExp(r'https?://\S+').firstMatch(text);
    return m?.group(0);
  }
}

enum CompanionStatus { unsupported, needsPermission, off, on }

/// Android companion bubble (overlay) and share intake. iOS has no overlay;
/// there the rider opens the app normally.
class CompanionChannel {
  CompanionChannel() {
    if (Platform.isAndroid) _channel.setMethodCallHandler(_onCall);
  }

  static const _channel = MethodChannel('parkzumi/companion');
  final _intents = StreamController<LaunchIntent>.broadcast();

  Stream<LaunchIntent> get intents => _intents.stream;

  Future<LaunchIntent?> initialIntent() async {
    if (!Platform.isAndroid) return null;
    try {
      return _parse(await _channel.invokeMapMethod<String, Object?>('initialIntent'));
    } on PlatformException {
      return null;
    }
  }

  Future<CompanionStatus> status() async {
    if (!Platform.isAndroid) return CompanionStatus.unsupported;
    try {
      final s = await _channel.invokeMapMethod<String, Object?>('status');
      if (s?['canDrawOverlays'] != true) return CompanionStatus.needsPermission;
      return s?['running'] == true ? CompanionStatus.on : CompanionStatus.off;
    } on PlatformException {
      return CompanionStatus.unsupported;
    } on MissingPluginException {
      return CompanionStatus.unsupported;
    }
  }

  Future<void> requestPermission() => _channel.invokeMethod('requestOverlayPermission');
  Future<void> start() => _channel.invokeMethod('start');
  Future<void> stop() => _channel.invokeMethod('stop');

  Future<void> _onCall(MethodCall call) async {
    if (call.method == 'launchIntent') {
      final intent = _parse((call.arguments as Map?)?.cast<String, Object?>());
      if (intent != null) _intents.add(intent);
    }
  }

  static LaunchIntent? _parse(Map<String, Object?>? m) {
    if (m == null) return null;
    return switch (m['type']) {
      'checkHere' => const CheckHereIntent(),
      'sharedText' when m['text'] is String => SharedPlaceIntent(m['text']! as String),
      _ => null,
    };
  }
}
