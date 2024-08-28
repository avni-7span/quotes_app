part of 'quote_data_bloc.dart';

class QuoteEvent extends Equatable {
  const QuoteEvent();
  @override
  List<Object?> get props => [];
}

class FetchQuoteDataEvent extends QuoteEvent {
  const FetchQuoteDataEvent();
}

class FetchAdminDetailEvent extends QuoteEvent {
  const FetchAdminDetailEvent();
}

class GenerateSetOfRandomIntegerEvent extends QuoteEvent {
  const GenerateSetOfRandomIntegerEvent();
}

class TakeScreenShotAndShareEvent extends QuoteEvent {
  const TakeScreenShotAndShareEvent({required this.screenshotController});
  final ScreenshotController screenshotController;
}

class ShareAsTextEvent extends QuoteEvent {
  const ShareAsTextEvent();
}

class CopyQuoteToClipBoardEvent extends QuoteEvent {
  const CopyQuoteToClipBoardEvent();
}

class CurrentIndexChangeEvent extends QuoteEvent {
  const CurrentIndexChangeEvent({required this.index});
  final int? index;
}

class FetchListOfFavouriteQuoteEvent extends QuoteEvent {
  const FetchListOfFavouriteQuoteEvent();
}

class AddToFavouriteEvent extends QuoteEvent {
  const AddToFavouriteEvent({required this.docID});
  final String docID;
}

class RemoveFromFavouriteEvent extends QuoteEvent {
  const RemoveFromFavouriteEvent({required this.docID});
  final String docID;
}

class HandleBookMarkEvent extends QuoteEvent {
  const HandleBookMarkEvent({required this.quote});
  final QuoteModel quote;
}
