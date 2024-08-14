import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/model/quote_data_model/quotes_data_model.dart';
import 'package:quotes_app/core/model/user_model/user_model.dart';

part 'quote_data_event.dart';

part 'quote_data_state.dart';

final fireStoreInstance = FirebaseFirestore.instance;
final firebaseAuth = firebase_auth.FirebaseAuth.instance;

class QuoteDataBloc extends Bloc<QuoteDataEvent, QuoteDataState> {
  QuoteDataBloc() : super(const QuoteDataState()) {
    on<FetchQuoteDataEvent>(fetchQuoteData);
    on<FetchAdminDetailEvent>(fetchAdminDetails);
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
      emit(state.copyWith(status: QuoteStateStatus.error));
    }
  }

  Future<void> fetchAdminDetails(
      FetchAdminDetailEvent event, Emitter<QuoteDataState> emit) async {
    try {
      emit(state.copyWith(status: QuoteStateStatus.loading));
      final docSnapShot = await fireStoreInstance
          .collection('users')
          .doc(firebaseAuth.currentUser?.uid)
          .get();
      final user = User.fromFireStore(docSnapShot);
      emit(state.copyWith(status: QuoteStateStatus.adminFetched, user: user));
    } catch (e) {
      emit(state.copyWith(status: QuoteStateStatus.error));
    }
  }
}
