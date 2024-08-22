import 'package:formz/formz.dart';

enum EmailValidationError { invalid, empty }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();
  static final RegExp emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  EmailValidationError? validator(String? value) {
    if (value == null || value == '') {
      return EmailValidationError.empty;
    } else if (!emailRegExp.hasMatch(value)) {
      return EmailValidationError.invalid;
    } else {
      return null;
    }
  }
}
