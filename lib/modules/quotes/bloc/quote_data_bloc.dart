import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/quote_data_model/quotes_data_model.dart';

part 'quote_data_event.dart';

part 'quote_data_state.dart';

final fireStoreInstance = FirebaseFirestore.instance;

class QuoteDataBloc extends Bloc<QuoteDataEvent, QuoteDataState> {
  QuoteDataBloc() : super(const QuoteDataState()) {
    on<FetchQuoteDataEvent>((event, emit) {
      fetchQuoteData;
    });
  }

  Future<void> fetchQuoteData(
      FetchQuoteDataEvent event, Emitter<QuoteDataState> emit) async {
    try {
      emit(state.copyWith(status: QuoteStateStatus.loading));
      final docSnapShot = await fireStoreInstance
          .collection('motivational_quotes')
          .doc('quote_1')
          .get();
      if (docSnapShot.exists) {
        final quote = Quotes.fromFireStore(docSnapShot);
        emit(state.copyWith(status: QuoteStateStatus.loaded, quote: quote));
      } else {
        emit(state.copyWith(status: QuoteStateStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: QuoteStateStatus.error));
    }
  }
}
