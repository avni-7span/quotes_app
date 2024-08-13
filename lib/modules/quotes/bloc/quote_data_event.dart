part of 'quote_data_bloc.dart';

class QuoteDataEvent extends Equatable {
  const QuoteDataEvent();
  @override
  List<Object?> get props => [];
}

class FetchQuoteDataEvent extends QuoteDataEvent {
  const FetchQuoteDataEvent();
  // final int quoteNumber;
}
