import 'dart:async';

import '../../domain/models.dart';

/// Demo fault injection between the rider app and the simulated server.
/// One-shot faults reset after they fire.
class NetworkConditions {
  NetworkConditions({
    this.online = true,
    this.dropNextResponse = false,
    this.failNextRequests = 0,
    this.latency = const Duration(milliseconds: 350),
    this.aiTimeout = false,
    this.aiMalformed = false,
  });

  bool online;

  /// The server applies the next write, then the response is lost.
  bool dropNextResponse;
  int failNextRequests;
  Duration latency;
  bool aiTimeout;
  bool aiMalformed;

  final _changes = StreamController<void>.broadcast();
  Stream<void> get changes => _changes.stream;

  /// Called after every change, e.g. to persist settings.
  void Function(NetworkConditions)? onChanged;

  void update(void Function(NetworkConditions n) change) {
    change(this);
    onChanged?.call(this);
    _changes.add(null);
  }

  Json toJson() => {
        'online': online,
        'dropNextResponse': dropNextResponse,
        'failNextRequests': failNextRequests,
        'latencyMs': latency.inMilliseconds,
        'aiTimeout': aiTimeout,
        'aiMalformed': aiMalformed,
      };

  void restore(Json j) {
    online = j['online'] as bool? ?? true;
    dropNextResponse = j['dropNextResponse'] as bool? ?? false;
    failNextRequests = j['failNextRequests'] as int? ?? 0;
    latency = Duration(milliseconds: j['latencyMs'] as int? ?? 350);
    aiTimeout = j['aiTimeout'] as bool? ?? false;
    aiMalformed = j['aiMalformed'] as bool? ?? false;
  }
}
