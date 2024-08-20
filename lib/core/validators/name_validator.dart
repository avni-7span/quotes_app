import 'package:formz/formz.dart';

enum AuthorNameValidatorError { invalid }

class Name extends FormzInput<String, AuthorNameValidatorError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  @override
  AuthorNameValidatorError? validator(String? value) {
    if (value == null || value == '') {
      return AuthorNameValidatorError.invalid;
    } else {
      return null;
    }
  }
}
