part of 'admin_quote_list_bloc.dart';

enum AdminQuoteListStateStatus {
  initial,
  fetching,
  loaded,
  failure,
  loading,
  deleted,
  updated
}

class AdminQuoteListState extends Equatable {
  const AdminQuoteListState(
      {this.error = '',
      this.status = AdminQuoteListStateStatus.initial,
      this.listOfAdminQuotes = const []});

  final String? error;
  final AdminQuoteListStateStatus status;
  final List<Quotes> listOfAdminQuotes;

  @override
  List<Object?> get props => [status, error, listOfAdminQuotes];

  AdminQuoteListState copyWith({
    String? error,
    AdminQuoteListStateStatus? status,
    List<Quotes>? listOfAdminQuotes,
  }) {
    return AdminQuoteListState(
      error: error ?? this.error,
      status: status ?? this.status,
      listOfAdminQuotes: listOfAdminQuotes ?? this.listOfAdminQuotes,
    );
  }
}
