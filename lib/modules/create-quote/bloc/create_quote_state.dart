part of 'create_quote_bloc.dart';

enum CreateQuoteStateStatus { loading, initial, success, failure, addQuote }

class CreateQuoteState extends Equatable {
  const CreateQuoteState({
    this.status = CreateQuoteStateStatus.initial,
    this.isValid = false,
    this.quote = const Field.pure(),
  });

  final CreateQuoteStateStatus status;
  final bool isValid;
  final Field quote;

  @override
  List<Object?> get props => [status, isValid, quote];

  CreateQuoteState copyWith({
    CreateQuoteStateStatus? status,
    bool? isValid,
    Field? quote,
  }) {
    return CreateQuoteState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      quote: quote ?? this.quote,
    );
  }
}
