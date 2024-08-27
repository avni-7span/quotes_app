import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/model/quote-data-model/quotes_model.dart';

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
          .where('created_by', isEqualTo: firebaseAuth.currentUser?.uid)
          .get();
      final listOfQuotes = querySnapShot.docs
          .map(
            (snapshot) => Quotes.fromFireStore(snapshot.data()),
          )
          .toList();
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
      final reference =
          fireStoreInstance.collection('motivational_quotes').doc(event.docID);
      final snapshot = await reference.get();
      print('update pela idlist : ${snapshot.data()?['id']}');
      await reference.update({
        'quote': event.quote,
        'author': event.author == null || event.author == ''
            ? 'unknown'
            : event.author
      });
      final idList = snapshot.data()?['id'];
      print('update pachhi idList : $idList');
      state.listOfAdminQuotes.removeWhere(
        (element) => element.docID == event.docID,
      );
      state.listOfAdminQuotes.add(Quotes(
        author: event.author,
        quote: event.quote,
        createdBy: firebaseAuth.currentUser!.uid,
        docID: event.docID,
        id: idList,
      ));
      emit(state.copyWith(status: AdminQuoteListStateStatus.updated));
      emit(
        state.copyWith(
            status: AdminQuoteListStateStatus.loaded,
            listOfAdminQuotes: state.listOfAdminQuotes),
      );
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
      emit(state.copyWith(status: AdminQuoteListStateStatus.deleted));
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
