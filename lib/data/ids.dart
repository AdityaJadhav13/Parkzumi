import 'dart:math';

final _rng = Random.secure();

/// Client-generated id, stable across retries of the same operation.
String newId(String prefix) {
  final rand = List.generate(8, (_) => _rng.nextInt(36).toRadixString(36)).join();
  return '$prefix-${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}-$rand';
}

/// FNV-1a: a hash that stays the same across app launches (String.hashCode
/// is not guaranteed to), used to derive notification ids.
int stableHash(String s) {
  var h = 0x811c9dc5;
  for (final c in s.codeUnits) {
    h ^= c;
    h = (h * 0x01000193) & 0xffffffff;
  }
  return h;
}
