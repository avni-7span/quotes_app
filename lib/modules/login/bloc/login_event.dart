part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class EmailFieldChangeEvent extends LoginEvent {
  const EmailFieldChangeEvent(this.email);
  final String email;
}

class PasswordFieldChangeEvent extends LoginEvent {
  const PasswordFieldChangeEvent(this.password);
  final String password;
}

class LoginButtonPressedEvent extends LoginEvent {
  const LoginButtonPressedEvent();
}

class SendVerificationEmail extends LoginEvent {
  const SendVerificationEmail();
}
