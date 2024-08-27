part of 'quote_data_bloc.dart';

enum QuoteStateStatus {
  initial,
  loading,
  loaded,
  error,
  adminFetched,
  copiedSuccessfully
}

class QuoteDataState extends Equatable {
  const QuoteDataState({
    this.status = QuoteStateStatus.initial,
    this.listOfQuotes = const [],
    this.user = User.empty,
    this.currentIndex,
    this.isFavourite = false,
    this.listOfFavouriteQuotes = const [],
  });

  final QuoteStateStatus status;
  final List<Quotes> listOfQuotes;
  final User user;
  final int? currentIndex;
  final bool isFavourite;
  final List<Quotes> listOfFavouriteQuotes;

  @override
  List<Object?> get props => [
        status,
        listOfQuotes,
        user,
        currentIndex,
        isFavourite,
        listOfFavouriteQuotes
      ];

  QuoteDataState copyWith({
    QuoteStateStatus? status,
    List<Quotes>? listOfQuotes,
    User? user,
    int? currentIndex,
    bool? isFavourite,
    List<Quotes>? listOfFavouriteQuotes,
  }) {
    return QuoteDataState(
      status: status ?? this.status,
      listOfQuotes: listOfQuotes ?? this.listOfQuotes,
      user: user ?? this.user,
      currentIndex: currentIndex ?? this.currentIndex,
      isFavourite: isFavourite ?? this.isFavourite,
      listOfFavouriteQuotes:
          listOfFavouriteQuotes ?? this.listOfFavouriteQuotes,
    );
  }
}
