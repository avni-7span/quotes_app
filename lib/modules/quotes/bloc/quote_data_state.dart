part of 'quote_data_bloc.dart';

enum QuoteStateStatus {
  initial,
  adminFetched,
  copiedSuccessfully,
  favouriteListLoaded,
  quoteListLoaded,
  loading,
  loaded
}

enum APIStatus {
  initial,
  loading,
  loaded,
  error,
}

class QuoteDataState extends Equatable {
  const QuoteDataState({
    this.status = QuoteStateStatus.initial,
    this.apiStatus = APIStatus.initial,
    this.quoteList = const [],
    this.user = UserModel.empty,
    this.isFavourite = false,

    // TODO
    this.currentIndex,
    this.favouriteQuoteList = const [],
  });

  final QuoteStateStatus status;
  final APIStatus apiStatus;
  final List<QuoteModel> quoteList;
  final UserModel user;
  final int? currentIndex;
  final List<QuoteModel> favouriteQuoteList;
  final bool isFavourite;

  @override
  List<Object?> get props => [
        status,
        quoteList,
        user,
        currentIndex,
        favouriteQuoteList,
        apiStatus,
        isFavourite
      ];

  QuoteDataState copyWith({
    QuoteStateStatus? status,
    APIStatus? apiStatus,
    List<QuoteModel>? quoteList,
    UserModel? user,
    int? currentIndex,
    List<QuoteModel>? favouriteQuoteList,
    bool? isFavourite,
  }) {
    return QuoteDataState(
      status: status ?? this.status,
      apiStatus: apiStatus ?? this.apiStatus,
      quoteList: quoteList ?? this.quoteList,
      user: user ?? this.user,
      currentIndex: currentIndex ?? this.currentIndex,
      favouriteQuoteList: favouriteQuoteList ?? this.favouriteQuoteList,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
