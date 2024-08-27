import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { invalid, passEmpty }

class ConfirmPassword
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPassword.pure([this.password]) : super.pure('');

  const ConfirmPassword.dirty([super.value = '', this.password])
      : super.dirty();

  final String? password;

  static final passwordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  ConfirmPasswordValidationError? validator(String? value) {
    if (value == '' || value == null) {
      return ConfirmPasswordValidationError.passEmpty;
    } else if (password != null && password == value) {
      return null;
    } else {
      return ConfirmPasswordValidationError.invalid;
    }
  }
}
