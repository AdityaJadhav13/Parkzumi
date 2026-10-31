/// Mumbai wall-clock helpers.
///
/// Asia/Kolkata is a fixed UTC+05:30 offset with no daylight saving, so a
/// constant offset is exact and the domain needs no time-zone database.
library;

const istOffset = Duration(hours: 5, minutes: 30);

/// IST wall-clock fields of [instant], carried in a UTC DateTime.
/// Only read its fields; never compare it with real instants.
DateTime istWall(DateTime instant) => instant.toUtc().add(istOffset);

/// The instant at an IST wall-clock time.
DateTime istInstant(int year, int month, int day, [int hour = 0, int minute = 0]) =>
    DateTime.utc(year, month, day, hour, minute).subtract(istOffset);

int istMinuteOfDay(DateTime instant) {
  final w = istWall(instant);
  return w.hour * 60 + w.minute;
}

/// Start (00:00 IST) of the IST calendar day containing [instant].
DateTime istStartOfDay(DateTime instant) {
  final w = istWall(instant);
  return istInstant(w.year, w.month, w.day);
}

String formatMinuteOfDay(int minute) {
  final m = minute % 1440;
  final h24 = m ~/ 60;
  final mm = m % 60;
  final suffix = h24 < 12 ? 'am' : 'pm';
  final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
  return mm == 0 ? '$h12 $suffix' : '$h12:${mm.toString().padLeft(2, '0')} $suffix';
}

String formatIstTime(DateTime instant) => formatMinuteOfDay(istMinuteOfDay(instant));

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

String formatIstDate(DateTime instant) {
  final w = istWall(instant);
  return '${_weekdays[w.weekday - 1]} ${w.day} ${_months[w.month - 1]}';
}

String formatIstDateTime(DateTime instant) => '${formatIstDate(instant)}, ${formatIstTime(instant)}';

String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  if (h == 0) return '$m min';
  if (m == 0) return '$h h';
  return '$h h $m min';
}

String formatAge(Duration d) {
  if (d.inMinutes < 1) return 'just now';
  if (d.inMinutes < 60) return '${d.inMinutes} min ago';
  if (d.inHours < 48) return '${d.inHours} h ago';
  return '${d.inDays} days ago';
}
