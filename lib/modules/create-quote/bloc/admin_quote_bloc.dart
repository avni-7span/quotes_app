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
    on<AdminQuoteEvent>((event, emit) {});

    on<AddQuoteToFireStoreEvent>(addQuoteToFireStore);

    on<QuoteFieldChangeEvent>((event, emit) {
      final quote = Field.dirty(event.quote);
      emit(
        state.copyWith(
          quote: quote,
          isValid: Formz.validate([quote]),
        ),
      );
    });
  }

  Future<void> addQuoteToFireStore(
      AddQuoteToFireStoreEvent event, Emitter<AdminQuoteState> emit) async {
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
        await fireStoreInstance.collection('motivational_quotes').add({
          'quote': state.quote.value,
          'author': author,
          'id': currentUser?.uid
        });
        emit(state.copyWith(status: AdminQuoteStateStatus.success));
      } else {
        emit(state.copyWith(status: AdminQuoteStateStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: AdminQuoteStateStatus.failure));
    }
  }
}
