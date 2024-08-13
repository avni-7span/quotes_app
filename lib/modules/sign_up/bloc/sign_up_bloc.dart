import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:quotes_app/core/authentication%20repository/authentication_repository.dart';
import 'package:quotes_app/core/validators/email_validator.dart';
import 'package:quotes_app/core/validators/password_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState(status: SignUpStateStatus.initial)) {
    on<EmailChangeEvent>((event, emit) {
      final email = Email.dirty(event.email);
      emit(
        state.copyWith(
          email: email,
          isValid: Formz.validate([email]),
        ),
      );
    });
    on<PasswordChangeEvent>((event, emit) {
      final password = Password.dirty(event.password);
      emit(
        state.copyWith(
          password: password,
          isValid: Formz.validate([password]),
        ),
      );
    });
    on<AdminCheckEvent>(
      (event, emit) {
        emit(state.copyWith(isAdmin: event.isAdmin));
      },
    );
    on<SignUpEvent>((event, emit) async {
      final email = Email.dirty(state.email.value);
      final password = Password.dirty(state.password.value);
      emit(
        state.copyWith(
          isValid: Formz.validate([email, password]),
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
            'isAdmin': state.isAdmin
          });
          emit(state.copyWith(status: SignUpStateStatus.success));
        } catch (e) {
          emit(state.copyWith(status: SignUpStateStatus.failure));
        }
      }
    });
  }
}
