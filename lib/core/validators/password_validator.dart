import 'package:formz/formz.dart';

enum PasswordValidationError { invalid, passEmpty, confirmPassEmpty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty([super.value = '']) : super.dirty();

  static final passwordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  PasswordValidationError? validator(String? value) {
    if (value == '' || value == null) {
      return PasswordValidationError.passEmpty;
    } else {
      return passwordRegExp.hasMatch(value)
          ? null
          : PasswordValidationError.invalid;
    }
  }
}
