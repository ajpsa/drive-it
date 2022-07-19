
import 'package:flutter_test/flutter_test.dart';
import 'package:p1/authenticate/sign_in.dart';

void main() {

  test('If the email is empty a error string is returned', () {

    final result = EmailFieldValidator.validate('');
    expect(result, 'Email cannot be empty');
  });

  test('If the email is non-valid then an error is returned', () {

    final result = EmailFieldValidator.validate('email');
    expect(result, 'Please enter a valid email');
  });

  test('If the password is empty error string is returned', () {

    final result = PasswordFieldValidator.validate('');
    expect(result, 'Password cannot be empty');
  });

  test('If the password is non-valid error is returned', () {

    final result = PasswordFieldValidator.validate('pass');
    expect(result, 'please enter valid password min. 6 character');
  });
  test('check email validity', () {

    final result = EmailFieldValidator.validate('pradeeptrader3@gmail.com');
    expect(result, null);
  });
  test('check password validity', () {

    final result = PasswordFieldValidator.validate('psa@123');
    expect(result, null);
  });
}