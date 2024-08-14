part of 'admin_quote_bloc.dart';

enum AdminQuoteStateStatus { loading, initial, loaded, success, failure }

class AdminQuoteState extends Equatable {
  const AdminQuoteState({this.status = AdminQuoteStateStatus.initial});

  final AdminQuoteStateStatus status;

  @override
  List<Object?> get props => [status];

  AdminQuoteState copyWith({
    AdminQuoteStateStatus? status,
  }) {
    return AdminQuoteState(
      status: status ?? this.status,
    );
  }
}
