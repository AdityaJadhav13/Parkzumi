import 'package:measure_flutter/measure_flutter.dart';

/// Sends the app's diagnostic events to Measure (measure.sh).
///
/// Events that carry a duration (`ms`, `renderMs`) become spans covering that
/// duration — time to answer a spot, photo-check latency, tip delivery — and
/// everything else becomes a custom event on the session timeline. Enabled with
/// `MEASURE_ENABLED=true` plus native credentials (see README).
abstract final class MeasureBridge {
  static const enabled = bool.fromEnvironment('MEASURE_ENABLED');

  static void forward(String type, String origin, String? correlationId, Map<String, Object?> attrs) {
    // Measure names allow only [a-zA-Z0-9_-]; values are capped at 256 chars.
    final name = type.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final attributes = <String, AttributeValue>{
      'origin': StringAttr(origin),
      if (correlationId != null) 'correlation_id': StringAttr(correlationId),
      for (final e in attrs.entries)
        if (e.value case final int v)
          e.key: IntAttr(v)
        else if (e.value case final bool v)
          e.key: BooleanAttr(v)
        else if (e.value case final num v)
          e.key: DoubleAttr(v.toDouble())
        else if (e.value != null)
          e.key: StringAttr(_clip('${e.value}')),
    };
    final ms = attrs['ms'] ?? attrs['renderMs'];
    if (ms is int) {
      final end = Measure.instance.getCurrentTime();
      Measure.instance.startSpan(name, timestamp: end - ms)
        ..setAttributes(attributes)
        ..setStatus(SpanStatus.ok)
        ..end(timestamp: end);
    } else {
      Measure.instance.trackEvent(name: name, attributes: attributes);
    }
  }

  static String _clip(String s) => s.length <= 256 ? s : s.substring(0, 256);
}
