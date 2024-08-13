part of 'sign_up_bloc.dart';

enum SignUpStateStatus { initial, loading, success, failure, error }

class SignUpState extends Equatable {
  const SignUpState(
      {this.status = SignUpStateStatus.initial,
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.isValid = false,
      this.isAdmin = false});

  final SignUpStateStatus status;
  final Email email;
  final Password password;
  final bool isValid;
  final bool isAdmin;

  @override
  List<Object?> get props => [status, password, email, isValid, isAdmin];

  SignUpState copyWith({
    SignUpStateStatus? status,
    Email? email,
    Password? password,
    bool? isValid,
    bool? isAdmin,
  }) {
    return SignUpState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
