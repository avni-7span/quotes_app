import 'package:formz/formz.dart';

enum AuthorNameValidatorError { invalid }

class Field extends FormzInput<String, AuthorNameValidatorError> {
  const Field.pure() : super.pure('');
  const Field.dirty([super.value = '']) : super.dirty();

  @override
  AuthorNameValidatorError? validator(String? value) {
    if (value == null || value == '') {
      return AuthorNameValidatorError.invalid;
    } else {
      return null;
    }
  }
}
