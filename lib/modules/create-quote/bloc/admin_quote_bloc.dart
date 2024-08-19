import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:quotes_app/core/validators/name_validator.dart';

part 'admin_quote_event.dart';

part 'admin_quote_state.dart';

final fireStoreInstance = FirebaseFirestore.instance;
final currentUser = FirebaseAuth.instance.currentUser;

class AdminQuoteBloc extends Bloc<AdminQuoteEvent, AdminQuoteState> {
  AdminQuoteBloc() : super(const AdminQuoteState()) {
    on<AdminQuoteEvent>((event, emit) {});
    on<AddQuoteToFireStoreEvent>((event, emit) async {
      try {
        final quote = Name.dirty(state.quote.value);
        final author = Name.dirty(state.author.value);
        emit(
          state.copyWith(
            isValid: Formz.validate([quote, author]),
          ),
        );
        if (state.isValid) {
          emit(state.copyWith(status: AdminQuoteStateStatus.addQuote));
          await fireStoreInstance.collection('motivational_quotes').add({
            'quote': state.quote.value,
            'author': state.author.value,
            'id': currentUser?.uid
          });
          emit(state.copyWith(status: AdminQuoteStateStatus.success));
        } else {
          emit(state.copyWith(status: AdminQuoteStateStatus.failure));
          print('state valid nathi');
        }
      } catch (e) {
        emit(state.copyWith(status: AdminQuoteStateStatus.failure));
        print('error aavi 1 : $e');
      }
    });
    on<QuoteFieldChangeEvent>((event, emit) {
      emit(state.copyWith(status: AdminQuoteStateStatus.loading));
      final quote = Name.dirty(event.quote);
      emit(
        state.copyWith(
          quote: quote,
          isValid: Formz.validate([quote]),
        ),
      );
    });
    on<AuthorFieldChangeEvent>((event, emit) {
      final author = Name.dirty(event.authorName);
      emit(
        state.copyWith(
          author: author,
          isValid: Formz.validate([author]),
        ),
      );
    });
  }
}
