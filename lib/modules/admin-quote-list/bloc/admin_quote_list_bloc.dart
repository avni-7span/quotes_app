import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/model/quote-data-model/quotes_data_model.dart';

part 'admin_quote_list_event.dart';

part 'admin_quote_list_state.dart';

final fireStoreInstance = FirebaseFirestore.instance;
final firebaseAuth = FirebaseAuth.instance;

class AdminQuoteListBloc
    extends Bloc<AdminQuoteListEvent, AdminQuoteListState> {
  AdminQuoteListBloc()
      : super(const AdminQuoteListState(
            status: AdminQuoteListStateStatus.initial)) {
    on<FetchingAdminQuoteListEvent>(_fetchAdminQuoteList);
    on<EditQuoteEvent>(_editQuote);
    on<DeleteQuoteEvent>(_deleteQuote);
  }

  Future<void> _fetchAdminQuoteList(FetchingAdminQuoteListEvent event,
      Emitter<AdminQuoteListState> emit) async {
    try {
      emit(state.copyWith(status: AdminQuoteListStateStatus.fetching));
      final querySnapShot = await fireStoreInstance
          .collection('motivational_quotes')
          .where('id', isEqualTo: firebaseAuth.currentUser?.uid)
          .get();
      final listOfQuotes = querySnapShot.docs.map((doc) {
        final data = doc.data();

        return Quotes(
          docID: doc.id,
          author: data['author'],
          quote: data['quote'],
          adminId: data['id'],
        );
      }).toList();
      emit(
        state.copyWith(
            listOfAdminQuotes: listOfQuotes,
            status: AdminQuoteListStateStatus.loaded),
      );
    } catch (e) {
      emit(
        state.copyWith(
            status: AdminQuoteListStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _editQuote(
      EditQuoteEvent event, Emitter<AdminQuoteListState> emit) async {
    try {
      emit(state.copyWith(status: AdminQuoteListStateStatus.loading));
      await fireStoreInstance
          .collection('motivational_quotes')
          .doc(event.docID)
          .update({
        'quote': event.quote,
        'author': event.author == null || event.author == ''
            ? 'unknown'
            : event.author
      });
      final quoteData = await fireStoreInstance
          .collection('motivational_quotes')
          .doc(event.docID)
          .get();
      final quote = quoteData.data();
      print('aavelo quote map : $quote');
      // add(const FetchingAdminQuoteListEvent());
      // emit(state.copyWith(status: AdminQuoteListStateStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminQuoteListStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _deleteQuote(
      DeleteQuoteEvent event, Emitter<AdminQuoteListState> emit) async {
    try {
      emit(state.copyWith(status: AdminQuoteListStateStatus.loading));
      await fireStoreInstance
          .collection('motivational_quotes')
          .doc(event.docID)
          .delete();
      state.listOfAdminQuotes.removeWhere(
        (element) => element.docID == event.docID,
      );
      emit(state.copyWith(
          listOfAdminQuotes: state.listOfAdminQuotes,
          status: AdminQuoteListStateStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminQuoteListStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
