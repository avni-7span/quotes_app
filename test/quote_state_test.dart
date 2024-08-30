import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quotes_app/core/model/user-model/user_model.dart';
import 'package:quotes_app/modules/home/bloc/quote_data_bloc.dart';

class MockQuoteState extends Mock {}

void main() {
  late QuoteState systemUnderTest;

  late MockQuoteState mockQuoteBloc;

  setUp(() {
    mockQuoteBloc = MockQuoteState();
    systemUnderTest = const QuoteState();
  });

  test(
    'initial values are correct',
    () {
      expect(systemUnderTest.quoteList, []);
      expect(systemUnderTest.favouriteQuoteList, []);
      expect(systemUnderTest.currentIndex, 0);
      expect(systemUnderTest.user, UserModel.empty);
      expect(systemUnderTest.status, QuoteStateStatus.initial);
      expect(systemUnderTest.apiStatus, APIStatus.initial);
    },
  );
}
