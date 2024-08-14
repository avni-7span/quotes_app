import 'package:formz/formz.dart';

enum AuthorNameValidatorError { invalid }

class Name extends FormzInput<String, AuthorNameValidatorError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  static final RegExp nameRegExp = RegExp(r'^[a-zA-Z. ]+$');

  @override
  AuthorNameValidatorError? validator(String value) {
    if (!nameRegExp.hasMatch(value)) {
      return AuthorNameValidatorError.invalid;
    } else {
      return null;
    }
  }
}
