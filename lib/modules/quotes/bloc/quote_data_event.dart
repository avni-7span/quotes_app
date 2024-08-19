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

class FetchAdminDetailEvent extends QuoteDataEvent {
  const FetchAdminDetailEvent();
}

class GenerateSetOfRandomIntegerEvent extends QuoteDataEvent {
  const GenerateSetOfRandomIntegerEvent();
}

class TakeScreenShotAndShareEvent extends QuoteDataEvent {
  const TakeScreenShotAndShareEvent(
      {required this.screenshotController, this.index = 0});
  final ScreenshotController screenshotController;
  final int index;
}

class ShareAsTextEvent extends QuoteDataEvent {
  const ShareAsTextEvent({required this.index});
  final int index;
}

class CopyQuoteToClipBoardEvent extends QuoteDataEvent {
  const CopyQuoteToClipBoardEvent({required this.index});
  final int index;
}
