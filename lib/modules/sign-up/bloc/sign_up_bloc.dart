import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:quotes_app/core/authentication-repository/authentication_failure.dart';
import 'package:quotes_app/core/authentication-repository/authentication_repository.dart';
import 'package:quotes_app/core/validators/confirm_password_validator.dart';
import 'package:quotes_app/core/validators/email_validator.dart';
import 'package:quotes_app/core/validators/password_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState()) {
    on<EmailChangeEvent>(_checkEmail);
    on<PasswordChangeEvent>(_checkPassword);
    on<ConfirmPasswordChangeEvent>(_checkConfirmPassword);
    on<AdminCheckEvent>(checkAdmin);
    on<SignUpButtonPressed>(signUpAndSendVerificationEmail);
  }

  void _checkEmail(
    EmailChangeEvent event,
    Emitter<SignUpState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email]),
      ),
    );
  }

  void _checkPassword(
    PasswordChangeEvent event,
    Emitter<SignUpState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password]),
      ),
    );
  }

  void _checkConfirmPassword(
    ConfirmPasswordChangeEvent event,
    Emitter<SignUpState> emit,
  ) {
    final confirmPass =
        ConfirmPassword.dirty(state.password.value, event.confirmPassword);
    emit(
      state.copyWith(
        confirmPassword: confirmPass,
        isValid: Formz.validate([confirmPass]),
      ),
    );
  }

  void checkAdmin(
    AdminCheckEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(isAdmin: event.isAdmin),
    );
  }

  Future<void> signUpAndSendVerificationEmail(
    SignUpButtonPressed event,
    Emitter<SignUpState> emit,
  ) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPass = ConfirmPassword.dirty(
        state.password.value, state.confirmPassword.value);
    emit(
      state.copyWith(
        email: email,
        password: password,
        confirmPassword: confirmPass,
        isValid: Formz.validate([email, password, confirmPass]),
      ),
    );
    if (state.isValid) {
      try {
        emit(state.copyWith(status: SignUpStateStatus.loading));
        final user = await AuthenticationRepository().signUpWithEmailPassword(
            email: state.email.value, password: state.password.value);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user?.uid)
            .set({
          'email': user.user?.email,
          'id': user.user?.uid,
          'isAdmin': state.isAdmin,
          'favourite_quote_id': []
        });
        await AuthenticationRepository().sendVerificationEmail();
        emit(state.copyWith(status: SignUpStateStatus.success));
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(
              status: SignUpStateStatus.failure,
              error: SignUpWithEmailAndPasswordFailure(e.code).message),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: SignUpStateStatus.failure,
            error: 'Something went wrong',
          ),
        );
      }
    }
  }
}
