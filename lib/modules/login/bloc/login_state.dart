part of 'login_bloc.dart';

enum LoginStateStatus {
  initial,
  loading,
  success,
  failure,
  emailChanging,
  passwordChanging,
  notVerified,
  emailSent
}

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStateStatus.initial,
    this.email = const Email.pure(),
    this.password = const Field.pure(),
    this.isValid = false,
    this.error = '',
    this.isVerified,
  });

  final LoginStateStatus status;
  final Email email;
  final Field password;
  final bool isValid;
  final String error;
  final bool? isVerified;

  @override
  List<Object?> get props =>
      [status, password, email, isValid, error, isVerified];

  LoginState copyWith({
    LoginStateStatus? status,
    Email? email,
    Field? password,
    bool? isValid,
    String? error,
    bool? isVerified,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
