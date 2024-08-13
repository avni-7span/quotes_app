import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/quote_data_model/quotes_data_model.dart';

part 'quote_data_event.dart';

part 'quote_data_state.dart';

final fireStoreInstance = FirebaseFirestore.instance;

class QuoteDataBloc extends Bloc<QuoteDataEvent, QuoteDataState> {
  QuoteDataBloc() : super(const QuoteDataState()) {
    on<FetchQuoteDataEvent>(fetchQuoteData);
  }

  Future<void> fetchQuoteData(
    FetchQuoteDataEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      emit(state.copyWith(status: QuoteStateStatus.loading));
      final querySnapShot =
          await fireStoreInstance.collection('motivational_quotes').get();
      final listOfDoc = querySnapShot.docs.map((doc) => doc.data()).toList();
      final List<Quotes> listOfQuote = [];
      for (var maps in listOfDoc) {
        listOfQuote.add(Quotes.fromFireStore(maps));
      }
      emit(state.copyWith(
          status: QuoteStateStatus.loaded, listOfQuotes: listOfQuote));
    } catch (e) {
      print('exception aavyu...$e');
      emit(state.copyWith(status: QuoteStateStatus.error));
    }
  }
}
