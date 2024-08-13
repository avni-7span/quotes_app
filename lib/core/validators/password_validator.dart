import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();
  static final RegExp passwordRegExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );

  @override
  PasswordValidationError? validator(String value) {
    if (!passwordRegExp.hasMatch(value)) {
      return PasswordValidationError.invalid;
    } else {
      return null;
    }
  }
}
