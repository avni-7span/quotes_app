part of 'admin_quote_bloc.dart';

enum AdminQuoteStateStatus {
  initial,
  loaded,
  failure,
  loading,
  deleted,
  edited
}

class AdminQuoteState extends Equatable {
  const AdminQuoteState({
    this.error = '',
    this.status = AdminQuoteStateStatus.initial,
    this.adminQuoteList = const [],
  });

  final String? error;
  final AdminQuoteStateStatus status;
  final List<QuoteModel> adminQuoteList;

  @override
  List<Object?> get props => [status, error, adminQuoteList];

  AdminQuoteState copyWith({
    String? error,
    AdminQuoteStateStatus? status,
    List<QuoteModel>? adminQuoteList,
  }) {
    return AdminQuoteState(
      error: error ?? this.error,
      status: status ?? this.status,
      adminQuoteList: adminQuoteList ?? this.adminQuoteList,
    );
  }
}
