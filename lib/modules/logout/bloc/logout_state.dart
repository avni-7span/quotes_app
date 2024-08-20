part of 'logout_bloc.dart';

enum LogoutStateStatus { initial, loading, success, failure }

class LogoutState extends Equatable {
  const LogoutState({
    this.status = LogoutStateStatus.initial,
    this.errorMessage = '',
  });

  final LogoutStateStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];

  LogoutState copyWith({
    LogoutStateStatus? status,
    String? errorMessage,
  }) {
    return LogoutState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
