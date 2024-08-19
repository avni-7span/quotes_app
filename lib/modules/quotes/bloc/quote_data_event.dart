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

class GenerateSetOfRandomInteger extends QuoteDataEvent {
  const GenerateSetOfRandomInteger();
}

class TakeScreenShotAndShare extends QuoteDataEvent {
  const TakeScreenShotAndShare(
      {required this.screenshotController, this.index = 0});
  final ScreenshotController screenshotController;
  final int index;
}
