part of 'sign_up_bloc.dart';

enum SignUpStateStatus { initial, loading, success, failure }

class SignUpState extends Equatable {
  const SignUpState(
      {this.status = SignUpStateStatus.initial,
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.isValid = false,
      this.isAdmin = false,
      this.error = ''});

  final SignUpStateStatus status;
  final Email email;
  final Password password;
  final bool isValid;
  final bool isAdmin;
  final String error;

  @override
  List<Object?> get props => [status, password, email, isValid, isAdmin, error];

  SignUpState copyWith({
    SignUpStateStatus? status,
    Email? email,
    Password? password,
    bool? isValid,
    bool? isAdmin,
    String? error,
  }) {
    return SignUpState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isAdmin: isAdmin ?? this.isAdmin,
      error: error ?? this.error,
    );
  }
}
