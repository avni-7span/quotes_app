part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
}

class EmailFieldChangeEvent extends ForgotPasswordEvent {
  const EmailFieldChangeEvent(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

class SendEmailForPasswordEvent extends ForgotPasswordEvent {
  const SendEmailForPasswordEvent();

  @override
  List<Object?> get props => [];
}
