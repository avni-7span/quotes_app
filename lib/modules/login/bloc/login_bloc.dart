import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:quotes_app/core/authentication-repository/authentication_failure.dart';
import 'package:quotes_app/core/authentication-repository/authentication_repository.dart';
import 'package:quotes_app/core/validators/email_validator.dart';
import 'package:quotes_app/core/validators/password_validator.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState(status: LoginStateStatus.initial)) {
    on<LoginEvent>((event, emit) {});
    on<EmailFieldChangeEvent>((event, emit) {
      emit(state.copyWith(status: LoginStateStatus.emailChanging));
      final email = Email.dirty(event.email);
      emit(
        state.copyWith(
          email: email,
          isValid: Formz.validate([email]),
        ),
      );
    });
    on<PasswordFieldChangeEvent>((event, emit) {
      emit(state.copyWith(status: LoginStateStatus.passwordChanging));
      final password = Password.dirty(event.password);
      emit(
        state.copyWith(
          password: password,
          isValid: Formz.validate([password]),
        ),
      );
    });
    on<LoginButtonPressedEvent>((event, emit) async {
      final email = Email.dirty(state.email.value);
      final password = Password.dirty(state.password.value);
      emit(
        state.copyWith(
          email: email,
          password: password,
          isValid: Formz.validate(
            [email, password],
          ),
        ),
      );
      if (state.isValid) {
        try {
          emit(state.copyWith(status: LoginStateStatus.loading));
          final user = await AuthenticationRepository().loginWithEmailPassword(
              email: state.email.value, password: state.password.value);
          emit(state.copyWith(status: LoginStateStatus.success));
        } on FirebaseException catch (e) {
          emit(
            state.copyWith(
                status: LoginStateStatus.failure,
                error: LogInWithEmailAndPasswordFailure(e.code).message),
          );
        } catch (e) {
          emit(state.copyWith(status: LoginStateStatus.failure));
        }
      }
    });
  }
}
