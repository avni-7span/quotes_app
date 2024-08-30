part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class EmailChangeEvent extends SignUpEvent {
  const EmailChangeEvent(this.email);
  final String email;
  @override
  List<Object?> get props => [email];
}

class PasswordChangeEvent extends SignUpEvent {
  const PasswordChangeEvent(this.password);
  final String password;
  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChangeEvent extends SignUpEvent {
  const ConfirmPasswordChangeEvent(this.confirmPassword);
  final String confirmPassword;
  @override
  List<Object?> get props => [confirmPassword];
}

class ToggleAdminEvent extends SignUpEvent {
  const ToggleAdminEvent(this.isAdmin);
  final bool isAdmin;
  @override
  List<Object?> get props => [isAdmin];
}

class SignUpButtonPressed extends SignUpEvent {
  const SignUpButtonPressed();
  @override
  List<Object?> get props => [];
}
