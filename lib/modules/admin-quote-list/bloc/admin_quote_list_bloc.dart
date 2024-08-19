import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    on<AdminQuoteListEvent>((event, emit) {});
    on<FetchingAdminQuoteListEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: AdminQuoteListStateStatus.fetching));
        final querySnapShot =
            await fireStoreInstance.collection('motivational_quotes').get();
        final listOfDoc = querySnapShot.docs.map((doc) => doc.data()).toList();
        final List<Quotes> listOfAdminQuote = [];
        for (var maps in listOfDoc) {
          if (maps['id'] == firebaseAuth.currentUser?.uid) {
            listOfAdminQuote.add(
              Quotes.fromFireStore(maps),
            );
          }
        }
        emit(
          state.copyWith(
              listOfAdminQuotes: listOfAdminQuote,
              status: AdminQuoteListStateStatus.loaded),
        );
      } catch (e) {
        emit(
          state.copyWith(
              status: AdminQuoteListStateStatus.failure, error: e.toString()),
        );
      }
    });
  }
}
