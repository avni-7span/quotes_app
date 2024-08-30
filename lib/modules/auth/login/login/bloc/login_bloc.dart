import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:quotes_app/core/authentication-repository/authentication_failure.dart';
import 'package:quotes_app/core/authentication-repository/authentication_repository.dart';
import 'package:quotes_app/core/validators/email_validator.dart';
import 'package:quotes_app/core/validators/empty_field_validator.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<EmailFieldChangeEvent>(_onEmailChanged);
    on<PasswordFieldChangeEvent>(_onPasswordChanged);
    on<LoginWithVerificationEvent>(_logInWithVerification);
    on<SendVerificationEmailEvent>(_sendVerificationEmail);
  }

  void _onEmailChanged(
    EmailFieldChangeEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(status: LoginStateStatus.emailChanging));
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email]),
      ),
    );
  }

  void _onPasswordChanged(
    PasswordFieldChangeEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(status: LoginStateStatus.passwordChanging));
    final password = Field.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password]),
      ),
    );
  }

  Future<void> _logInWithVerification(
    LoginWithVerificationEvent event,
    Emitter<LoginState> emit,
  ) async {
    final email = Email.dirty(state.email.value);
    final password = Field.dirty(state.password.value);
    emit(
      state.copyWith(
        email: email,
        password: password,
        isValid: Formz.validate([email, password]),
      ),
    );

    if (state.isValid) {
      try {
        emit(state.copyWith(status: LoginStateStatus.loading));

        await AuthenticationRepository.instance.loginWithEmailPassword(
          email: state.email.value,
          password: state.password.value,
        );

        final currentUser = AuthenticationRepository.instance.currentUser;

        /// this is new user made on log in
        /// (if we will not create new instance here,
        /// it will give old user details (stored when signup) which will surely not verified)
        final isVerified = currentUser?.emailVerified;

        if (isVerified ?? false) {
          emit(state.copyWith(status: LoginStateStatus.success));
        } else {
          emit(state.copyWith(status: LoginStateStatus.notVerified));
        }
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
  }

  Future<void> _sendVerificationEmail(
      SendVerificationEmailEvent event, Emitter<LoginState> emit) async {
    try {
      final userData = FirebaseAuth.instance.currentUser;
      await userData?.sendEmailVerification();
      emit(state.copyWith(status: LoginStateStatus.emailSent));
    } catch (e) {
      emit(state.copyWith(status: LoginStateStatus.failure));
    }
  }
}
