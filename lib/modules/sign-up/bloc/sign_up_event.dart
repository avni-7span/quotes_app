part of 'sign_up_bloc.dart';

class SignUpEvent extends Equatable {
  const SignUpEvent();
  @override
  List<Object?> get props => [];
}

class EmailChangeEvent extends SignUpEvent {
  const EmailChangeEvent(this.email);
  final String email;
}

class PasswordChangeEvent extends SignUpEvent {
  const PasswordChangeEvent(this.password);
  final String password;
}

class ConfirmPasswordChangeEvent extends SignUpEvent {
  const ConfirmPasswordChangeEvent(this.confirmPassword);
  final String confirmPassword;
}

class AdminCheckEvent extends SignUpEvent {
  const AdminCheckEvent(this.isAdmin);
  final bool isAdmin;
}

class SignUpButtonPressed extends SignUpEvent {
  const SignUpButtonPressed();
}
