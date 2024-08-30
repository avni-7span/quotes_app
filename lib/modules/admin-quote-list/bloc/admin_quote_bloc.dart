import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/model/quote-data-model/quotes_model.dart';

part 'admin_quote_event.dart';

part 'admin_quote_state.dart';

final fireStoreInstance = FirebaseFirestore.instance;
final firebaseAuth = FirebaseAuth.instance;

class AdminBloc extends Bloc<AdminQuoteEvent, AdminQuoteState> {
  AdminBloc() : super(const AdminQuoteState()) {
    on<FetchAdminQuoteListEvent>(_fetchAdminQuoteList);
    on<EditQuoteEvent>(_editQuote);
    on<DeleteQuoteEvent>(_deleteQuote);
  }

  Future<void> _fetchAdminQuoteList(
    FetchAdminQuoteListEvent event,
    Emitter<AdminQuoteState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AdminQuoteStateStatus.loading));

      /// get the quote list which is created by the current user
      final quoteListSnapShot = await fireStoreInstance
          .collection('motivational_quotes')
          .where('created_by', isEqualTo: firebaseAuth.currentUser?.uid)
          .get();

      final quoteList = quoteListSnapShot.docs
          .map(
            (snapshot) => QuoteModel.fromFireStore(
              snapshot.data(),
            ),
          )
          .toList();

      emit(
        state.copyWith(
          adminQuoteList: quoteList,
          status: AdminQuoteStateStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminQuoteStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  /// Things that are happening in this function:
  /// 1. Edit quote from firebase
  /// 2. Delete local quote
  /// 3. Add the updated quote
  /// Which is wrong
  // TODO
  Future<void> _editQuote(
    EditQuoteEvent event,
    Emitter<AdminQuoteState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AdminQuoteStateStatus.loading));

      final quoteDocument =
          fireStoreInstance.collection('motivational_quotes').doc(event.docID);

      await quoteDocument.update(
        {
          'quote': event.quote,
          'author': event.author == null || event.author == ''
              ? 'unknown'
              : event.author
        },
      );

      final adminQuoteList = List.of(state.adminQuoteList);

      adminQuoteList.removeWhere((quote) => quote.docID == event.docID);

      adminQuoteList.add(
        QuoteModel(
          author: event.author,
          quote: event.quote,
          createdBy: firebaseAuth.currentUser!.uid,
          docID: event.docID,
        ),
      );
      add(const FetchAdminQuoteListEvent());
      emit(
        state.copyWith(
          status: AdminQuoteStateStatus.edited,
          adminQuoteList: adminQuoteList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminQuoteStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _deleteQuote(
    DeleteQuoteEvent event,
    Emitter<AdminQuoteState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AdminQuoteStateStatus.loading));

      await fireStoreInstance
          .collection('motivational_quotes')
          .doc(event.quoteDocId)
          .delete();
      
      /// Good practice to have list like this; as we should not manipulate state directly.
      final adminQuoteList = List.of(state.adminQuoteList);

      adminQuoteList.removeWhere(
        (element) => element.docID == event.quoteDocId,
      );
      add(const FetchAdminQuoteListEvent());
      emit(
        state.copyWith(
          status: AdminQuoteStateStatus.deleted,
          adminQuoteList: adminQuoteList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminQuoteStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
