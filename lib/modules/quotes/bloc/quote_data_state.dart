part of 'quote_data_bloc.dart';

enum QuoteStateStatus { initial, loading, loaded, error }

class QuoteDataState extends Equatable {
  const QuoteDataState(
      {this.status = QuoteStateStatus.initial,
      this.quote = Quotes.emptyQuoteData});

  final QuoteStateStatus status;
  final Quotes quote;

  @override
  List<Object?> get props => [status, quote];

  QuoteDataState copyWith({
    QuoteStateStatus? status,
    Quotes? quote,
  }) {
    return QuoteDataState(
      status: status ?? this.status,
      quote: quote ?? this.quote,
    );
  }
}
