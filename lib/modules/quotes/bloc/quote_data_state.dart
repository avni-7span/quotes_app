part of 'quote_data_bloc.dart';

enum QuoteStateStatus { initial, loading, loaded, error }

class QuoteDataState extends Equatable {
  const QuoteDataState(
      {this.status = QuoteStateStatus.initial, this.listOfQuotes = const []});

  final QuoteStateStatus status;
  final List<Quotes> listOfQuotes;

  @override
  List<Object?> get props => [status, listOfQuotes];

  QuoteDataState copyWith({
    QuoteStateStatus? status,
    List<Quotes>? listOfQuotes,
  }) {
    return QuoteDataState(
      status: status ?? this.status,
      listOfQuotes: listOfQuotes ?? this.listOfQuotes,
    );
  }
}
