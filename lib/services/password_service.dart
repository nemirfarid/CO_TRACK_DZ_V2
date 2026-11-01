import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// PBKDF2-HMAC-SHA256, one 32-byte block, 120,000 rounds.
class PasswordService {
  static const int _rounds = 120000;
  static String salt() {
    final r = Random.secure();
    return List.generate(32, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  }
  static String hash(String password, String salt) {
    final hmac = Hmac(sha256, utf8.encode(salt));
    final input = <int>[...utf8.encode(password), 0, 0, 0, 1];
    var u = hmac.convert(input).bytes;
    final result = List<int>.from(u);
    for (var i = 1; i < _rounds; i++) {
      u = hmac.convert(u).bytes;
      for (var j = 0; j < result.length; j++) { result[j] ^= u[j]; }
    }
    return result.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
  static bool verify(String password, String saltValue, String expected) => _constantTime(hash(password, saltValue), expected);
  static bool _constantTime(String a, String b) {
    if (a.length != b.length) return false;
    var v = 0;
    for (var i = 0; i < a.length; i++) { v |= a.codeUnitAt(i) ^ b.codeUnitAt(i); }
    return v == 0;
  }
}
