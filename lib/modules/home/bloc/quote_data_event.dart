part of 'quote_data_bloc.dart';

abstract class QuoteEvent extends Equatable {
  const QuoteEvent();
}

class FetchQuoteDataEvent extends QuoteEvent {
  const FetchQuoteDataEvent();

  @override
  List<Object?> get props => [];
}

class FetchAdminDetailEvent extends QuoteEvent {
  const FetchAdminDetailEvent();

  @override
  List<Object?> get props => [];
}

class TakeScreenShotAndShareEvent extends QuoteEvent {
  const TakeScreenShotAndShareEvent({required this.screenshotController});

  final ScreenshotController screenshotController;

  @override
  List<Object?> get props => [screenshotController];
}

class ShareAsTextEvent extends QuoteEvent {
  const ShareAsTextEvent();

  @override
  List<Object?> get props => [];
}

class CopyQuoteToClipboardEvent extends QuoteEvent {
  const CopyQuoteToClipboardEvent();

  @override
  List<Object?> get props => [];
}

class CurrentIndexChangeEvent extends QuoteEvent {
  const CurrentIndexChangeEvent({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

class FetchListOfFavouriteQuoteEvent extends QuoteEvent {
  const FetchListOfFavouriteQuoteEvent();

  @override
  List<Object?> get props => [];
}

class HandleBookmarkEvent extends QuoteEvent {
  const HandleBookmarkEvent();

  @override
  List<Object?> get props => [];
}

class RemoveQuoteFromFavouriteList extends QuoteEvent {
  const RemoveQuoteFromFavouriteList({required this.docID});

  final String docID;

  @override
  List<Object?> get props => [docID];
}
