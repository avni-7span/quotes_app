part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class EmailFieldChangeEvent extends LoginEvent {
  const EmailFieldChangeEvent(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

class PasswordFieldChangeEvent extends LoginEvent {
  const PasswordFieldChangeEvent(this.password);
  final String password;

  @override
  List<Object?> get props => [password];
}

class LoginWithVerificationEvent extends LoginEvent {
  const LoginWithVerificationEvent();

  @override
  List<Object?> get props => [];
}

class SendVerificationEmailEvent extends LoginEvent {
  const SendVerificationEmailEvent();

  @override
  List<Object?> get props => [];
}
