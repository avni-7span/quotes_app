part of 'admin_quote_bloc.dart';

enum AdminQuoteStateStatus { loading, initial, success, failure, addQuote }

class AdminQuoteState extends Equatable {
  const AdminQuoteState(
      {this.status = AdminQuoteStateStatus.initial,
      this.isValid = false,
      this.quote = const Name.pure(),
      this.author = const Name.pure()});

  final AdminQuoteStateStatus status;
  final bool isValid;
  final Name quote;
  final Name author;

  @override
  List<Object?> get props => [status, isValid, quote, author];

  AdminQuoteState copyWith({
    AdminQuoteStateStatus? status,
    bool? isValid,
    Name? quote,
    Name? author,
  }) {
    return AdminQuoteState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      quote: quote ?? this.quote,
      author: author ?? this.author,
    );
  }
}
