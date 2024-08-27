import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:quotes_app/core/validators/email_validator.dart';

part 'forgot_password_event.dart';

part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(const ForgotPasswordState()) {
    on<EmailFieldChangeEvent>(_checkEmailField);
    on<SendEmailForPasswordEvent>(_sendEmailForPassword);
  }

  final authInstance = FirebaseAuth.instance;

  void _checkEmailField(
      EmailFieldChangeEvent event, Emitter<ForgotPasswordState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email]),
      ),
    );
  }

  Future<void> _sendEmailForPassword(SendEmailForPasswordEvent event,
      Emitter<ForgotPasswordState> emit) async {
    try {
      final email = Email.dirty(state.email.value);
      emit(
        state.copyWith(
          email: email,
          isValid: Formz.validate([email]),
        ),
      );
      if (state.isValid) {
        emit(state.copyWith(status: ForgotPasswordStateStatus.loading));
        await authInstance.sendPasswordResetEmail(email: state.email.value);
        emit(state.copyWith(status: ForgotPasswordStateStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: ForgotPasswordStateStatus.failure));
    }
  }
}
