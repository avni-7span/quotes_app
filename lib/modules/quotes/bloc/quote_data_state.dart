part of 'quote_data_bloc.dart';

enum QuoteStateStatus {
  initial,
  loading,
  loaded,
  error,
  adminFetched,
}

class QuoteDataState extends Equatable {
  const QuoteDataState(
      {this.status = QuoteStateStatus.initial,
      this.listOfQuotes = const [],
      this.user = User.empty});

  final QuoteStateStatus status;
  final List<Quotes> listOfQuotes;
  final User user;

  @override
  List<Object?> get props => [status, listOfQuotes, user];

  QuoteDataState copyWith({
    QuoteStateStatus? status,
    List<Quotes>? listOfQuotes,
    User? user,
  }) {
    return QuoteDataState(
      status: status ?? this.status,
      listOfQuotes: listOfQuotes ?? this.listOfQuotes,
      user: user ?? this.user,
    );
  }
}
