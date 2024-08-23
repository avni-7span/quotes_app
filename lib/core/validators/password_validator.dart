import 'package:formz/formz.dart';

enum PasswordValidationError { invalid, passEmpty, confirmPassEmpty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([this.confirmPassword]) : super.pure('');

  const Password.dirty([super.value = '', this.confirmPassword])
      : super.dirty();

  final String? confirmPassword;

  static final passwordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  PasswordValidationError? validator(String? value) {
    if (confirmPassword != null && confirmPassword == value) {
      return null;
    } else if (value == '' || value == null) {
      return PasswordValidationError.passEmpty;
    } else if (confirmPassword != null && confirmPassword != value) {
      return PasswordValidationError.invalid;
    } else {
      return passwordRegExp.hasMatch(value ?? '')
          ? null
          : PasswordValidationError.invalid;
    }
  }
}
