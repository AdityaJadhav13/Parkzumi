import 'time_ist.dart';

enum DateParity { odd, even }

/// A daily window in IST minutes. [endMinute] is exclusive and may be 1440.
/// A window whose end is before its start crosses midnight.
class TimeWindow {
  const TimeWindow(this.startMinute, this.endMinute);

  final int startMinute;
  final int endMinute;

  bool contains(int minute) => startMinute <= endMinute
      ? minute >= startMinute && minute < endMinute
      : minute >= startMinute || minute < endMinute;

  String describe() => '${formatMinuteOfDay(startMinute)}–${formatMinuteOfDay(endMinute)}';

  Map<String, Object?> toJson() => {'start': startMinute, 'end': endMinute};
  factory TimeWindow.fromJson(Map<String, Object?> j) => TimeWindow(j['start']! as int, j['end']! as int);
}

/// When a rule is in effect: weekdays, daily windows and an optional date parity
/// (Mumbai odd–even parking). Empty sets mean "every day" / "all day".
///
/// Weekday and parity are read from the IST calendar day of each instant, so a
/// window crossing midnight is judged against the date it is on at that moment.
class Schedule {
  const Schedule({this.weekdays = const {}, this.windows = const [], this.parity});

  static const always = Schedule();

  /// 1 = Monday … 7 = Sunday.
  final Set<int> weekdays;
  final List<TimeWindow> windows;
  final DateParity? parity;

  bool get isAlways => weekdays.isEmpty && windows.isEmpty && parity == null;

  bool isActiveAt(DateTime instant) {
    final w = istWall(instant);
    if (weekdays.isNotEmpty && !weekdays.contains(w.weekday)) return false;
    if (parity != null && (w.day.isOdd ? DateParity.odd : DateParity.even) != parity) return false;
    if (windows.isEmpty) return true;
    final minute = w.hour * 60 + w.minute;
    return windows.any((t) => t.contains(minute));
  }

  /// Every instant strictly inside (from, to) where [isActiveAt] can change.
  /// Activity is constant between consecutive boundaries, so probing one
  /// instant per segment evaluates a whole stay exactly.
  Iterable<DateTime> boundaries(DateTime from, DateTime to) sync* {
    var day = istStartOfDay(from);
    while (day.isBefore(to)) {
      if (day.isAfter(from)) yield day;
      for (final t in windows) {
        for (final m in [t.startMinute, t.endMinute]) {
          final b = day.add(Duration(minutes: m));
          if (b.isAfter(from) && b.isBefore(to)) yield b;
        }
      }
      day = day.add(const Duration(days: 1));
    }
  }

  String describe() {
    final parts = <String>[];
    if (parity != null) parts.add(parity == DateParity.even ? 'Even dates' : 'Odd dates');
    if (weekdays.isNotEmpty) parts.add(_describeWeekdays());
    if (windows.isNotEmpty) parts.add(windows.map((w) => w.describe()).join(', '));
    return parts.isEmpty ? 'At all times' : parts.join(' · ');
  }

  String _describeWeekdays() {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final days = weekdays.toList()..sort();
    if (days.length == 6 && !days.contains(7)) return 'Mon–Sat';
    if (days.length == 5 && days.every((d) => d <= 5)) return 'Mon–Fri';
    return days.map((d) => names[d - 1]).join(', ');
  }

  Map<String, Object?> toJson() => {
        'weekdays': weekdays.toList(),
        'windows': windows.map((w) => w.toJson()).toList(),
        'parity': parity?.name,
      };

  factory Schedule.fromJson(Map<String, Object?> j) => Schedule(
        weekdays: {...(j['weekdays'] as List? ?? const []).cast<int>()},
        windows: [
          for (final w in (j['windows'] as List? ?? const [])) TimeWindow.fromJson((w as Map).cast<String, Object?>()),
        ],
        parity: j['parity'] == null ? null : DateParity.values.byName(j['parity']! as String),
      );
}
