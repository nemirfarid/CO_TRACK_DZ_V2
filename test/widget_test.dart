import 'package:flutter_test/flutter_test.dart';
import 'package:co_track_dz/services/password_service.dart';

void main() {
  test('password hash verifies and is salt-dependent', () {
    final salt = PasswordService.salt();
    final hash = PasswordService.hash('test-password-123', salt);
    expect(PasswordService.verify('test-password-123', salt, hash), isTrue);
    expect(PasswordService.verify('wrong-password', salt, hash), isFalse);
    expect(PasswordService.hash('test-password-123', 'another-salt'), isNot(hash));
  });
}
