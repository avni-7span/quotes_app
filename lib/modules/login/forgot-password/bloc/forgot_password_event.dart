part of 'forgot_password_bloc.dart';

class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object?> get props => [];
}

class EmailFieldChangeEvent extends ForgotPasswordEvent {
  const EmailFieldChangeEvent(this.email);
  final String email;
}

class SendEmailForPasswordEvent extends ForgotPasswordEvent {
  const SendEmailForPasswordEvent();
}
