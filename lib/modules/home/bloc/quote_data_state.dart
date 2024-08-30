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

class QuoteState extends Equatable {
  const QuoteState({
    this.status = QuoteStateStatus.initial,
    this.apiStatus = APIStatus.initial,
    this.quoteList = const [],
    this.user = UserModel.empty,

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

  @override
  List<Object?> get props => [
        status,
        quoteList,
        user,
        currentIndex,
        favouriteQuoteList,
        apiStatus,
      ];

  QuoteState copyWith({
    QuoteStateStatus? status,
    APIStatus? apiStatus,
    List<QuoteModel>? quoteList,
    UserModel? user,
    int? currentIndex,
    List<QuoteModel>? favouriteQuoteList,
  }) {
    return QuoteState(
      status: status ?? this.status,
      apiStatus: apiStatus ?? this.apiStatus,
      quoteList: quoteList ?? this.quoteList,
      user: user ?? this.user,
      currentIndex: currentIndex ?? this.currentIndex,
      favouriteQuoteList: favouriteQuoteList ?? this.favouriteQuoteList,
    );
  }
}
