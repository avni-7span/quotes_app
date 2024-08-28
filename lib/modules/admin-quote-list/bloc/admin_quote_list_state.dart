part of 'admin_quote_list_bloc.dart';

enum AdminQuoteListStateStatus {
  initial,
  loaded,
  failure,
  loading,
  deleted,
  edited
}

class AdminQuoteListState extends Equatable {
  const AdminQuoteListState({
    this.error = '',
    this.status = AdminQuoteListStateStatus.initial,
    this.adminQuoteList = const [],
  });

  final String? error;
  final AdminQuoteListStateStatus status;
  final List<QuoteModel> adminQuoteList;

  @override
  List<Object?> get props => [status, error, adminQuoteList];

  AdminQuoteListState copyWith({
    String? error,
    AdminQuoteListStateStatus? status,
    List<QuoteModel>? adminQuoteList,
  }) {
    return AdminQuoteListState(
      error: error ?? this.error,
      status: status ?? this.status,
      adminQuoteList: adminQuoteList ?? this.adminQuoteList,
    );
  }
}
