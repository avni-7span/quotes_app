part of 'admin_quote_bloc.dart';

enum AdminQuoteStateStatus { loading, initial, success, failure, addQuote }

class AdminQuoteState extends Equatable {
  const AdminQuoteState({
    this.status = AdminQuoteStateStatus.initial,
    this.isValid = false,
    this.quote = const Field.pure(),
  });

  final AdminQuoteStateStatus status;
  final bool isValid;
  final Field quote;

  @override
  List<Object?> get props => [status, isValid, quote];

  AdminQuoteState copyWith({
    AdminQuoteStateStatus? status,
    bool? isValid,
    Field? quote,
  }) {
    return AdminQuoteState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      quote: quote ?? this.quote,
    );
  }
}
