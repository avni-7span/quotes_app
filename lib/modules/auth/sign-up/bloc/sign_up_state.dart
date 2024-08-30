part of 'sign_up_bloc.dart';

enum SignUpStateStatus { initial, loading, success, failure, emailSent }

class SignUpState extends Equatable {
  const SignUpState({
    this.status = SignUpStateStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.isValid = false,
    this.isAdmin = false,
    this.error = '',
  });

  final SignUpStateStatus status;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final bool isValid;
  final bool isAdmin;
  final String error;

  @override
  List<Object?> get props => [
        status,
        password,
        email,
        isValid,
        isAdmin,
        error,
        confirmPassword,
      ];

  SignUpState copyWith({
    SignUpStateStatus? status,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    bool? isValid,
    bool? isAdmin,
    String? error,
  }) {
    return SignUpState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isValid: isValid ?? this.isValid,
      isAdmin: isAdmin ?? this.isAdmin,
      error: error ?? this.error,
    );
  }
}
