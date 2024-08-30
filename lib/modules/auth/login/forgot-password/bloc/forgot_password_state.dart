part of 'forgot_password_bloc.dart';

enum ForgotPasswordStateStatus { initial, loading, success, failure }

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.status = ForgotPasswordStateStatus.initial,
    this.email = const Email.pure(),
    this.isValid = false,
  });

  final ForgotPasswordStateStatus status;
  final Email email;
  final bool isValid;

  @override
  List<Object?> get props => [status, email, isValid];

  ForgotPasswordState copyWith({
    ForgotPasswordStateStatus? status,
    Email? email,
    bool? isValid,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
      isValid: isValid ?? this.isValid,
    );
  }
}
