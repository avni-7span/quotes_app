import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:quotes_app/core/validators/empty_field_validator.dart';

part 'admin_quote_event.dart';

part 'admin_quote_state.dart';

final fireStoreInstance = FirebaseFirestore.instance;
final currentUser = FirebaseAuth.instance.currentUser;

class AdminQuoteBloc extends Bloc<AdminQuoteEvent, AdminQuoteState> {
  AdminQuoteBloc() : super(const AdminQuoteState()) {
    on<AddQuoteToFireStoreEvent>(_addQuoteToFireStore);
    on<QuoteFieldChangeEvent>(_checkQuoteField);
  }

  Future<void> _addQuoteToFireStore(
    AddQuoteToFireStoreEvent event,
    Emitter<AdminQuoteState> emit,
  ) async {
    try {
      final quote = Field.dirty(state.quote.value);
      String? author;
      emit(
        state.copyWith(
          quote: quote,
          isValid: Formz.validate([quote]),
        ),
      );
      if (state.isValid) {
        emit(state.copyWith(status: AdminQuoteStateStatus.addQuote));
        if (event.author == '') {
          author = 'unknown';
        } else {
          author = event.author;
        }
        final addedQuote = await fireStoreInstance
            .collection('motivational_quotes')
            .add({
          'quote': state.quote.value,
          'author': author,
          'created_by': currentUser?.uid
        });
        final quoteDocId = addedQuote.id;
        await fireStoreInstance
            .collection('motivational_quotes')
            .doc(quoteDocId)
            .update({'doc_id': quoteDocId});
        emit(state.copyWith(status: AdminQuoteStateStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: AdminQuoteStateStatus.failure));
    }
  }

  void _checkQuoteField(
    QuoteFieldChangeEvent event,
    Emitter<AdminQuoteState> emit,
  ) {
    final quote = Field.dirty(event.quote);
    emit(
      state.copyWith(
        quote: quote,
        isValid: Formz.validate([quote]),
      ),
    );
  }
}
