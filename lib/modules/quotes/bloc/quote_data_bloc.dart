import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotes_app/core/model/quote-data-model/quotes_model.dart';
import 'package:quotes_app/core/model/user-model/user_model.dart';
import 'package:quotes_app/modules/quotes/widgets/screenshot_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

part 'quote_data_event.dart';

part 'quote_data_state.dart';

final db = FirebaseFirestore.instance;
final firebaseAuthInstance = firebase_auth.FirebaseAuth.instance;
final currentUserUid = firebaseAuthInstance.currentUser?.uid;

class QuoteDataBloc extends Bloc<QuoteDataEvent, QuoteDataState> {
  QuoteDataBloc() : super(const QuoteDataState()) {
    on<FetchQuoteDataEvent>(_fetchQuoteData);
    on<FetchAdminDetailEvent>(_fetchAdminDetails);
    on<TakeScreenShotAndShareEvent>(_takeScreenShotAndShare);
    on<ShareAsTextEvent>(_shareAsText);
    on<CopyQuoteToClipBoardEvent>(_copyQuoteToClipboard);
    on<CurrentIndexChangeEvent>(_setCurrentIndex);
    on<FetchListOfFavouriteQuoteEvent>(_fetchListOfFavouriteQuote);
    on<AddToFavouriteEvent>(_addToFavourite);
    on<RemoveFromFavouriteEvent>(_removeFromFavourite);
    on<HandleBookMarkEvent>(_handleBookMark);
    on<FetchBookmarkInfoEvent>(_fetchBookmarkInfo);
  }

  Future<void> _fetchQuoteData(
    FetchQuoteDataEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      emit(state.copyWith(status: QuoteStateStatus.fetching));
      final querySnapShot = await db.collection('motivational_quotes').get();
      final listOfDoc = querySnapShot.docs.map((doc) => doc.data()).toList();
      final List<Quotes> listOfQuote = [];
      for (var maps in listOfDoc) {
        listOfQuote.add(
          Quotes.fromFireStore(maps),
        );
      }
      final List<Quotes> shuffledList = listOfQuote..shuffle();
      emit(
        state.copyWith(
            status: QuoteStateStatus.loaded, listOfQuotes: shuffledList),
      );
    } catch (e) {
      print('error aave chhe 1: ${e.toString()}');
      emit(state.copyWith(status: QuoteStateStatus.error));
    }
  }

  Future<void> _fetchAdminDetails(
      FetchAdminDetailEvent event, Emitter<QuoteDataState> emit) async {
    try {
      emit(state.copyWith(status: QuoteStateStatus.loading));
      final docSnapShot =
          await db.collection('users').doc(currentUserUid).get();
      final user = User.fromFireStore(docSnapShot);
      emit(state.copyWith(status: QuoteStateStatus.adminFetched, user: user));
    } catch (e) {
      print('error aave chhe 2 : ${e.toString()}');
      emit(state.copyWith(status: QuoteStateStatus.error));
    }
  }

  Future<void> _takeScreenShotAndShare(
    TakeScreenShotAndShareEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      final image = await event.screenshotController.captureFromWidget(
        pixelRatio: 2.0,
        Material(
          child: ScreenshotWidget(
            quote: state
                    .listOfQuotes[
                        state.currentIndex ?? state.listOfQuotes.length - 1]
                    .quote ??
                '',
            author: state
                    .listOfQuotes[
                        state.currentIndex ?? state.listOfQuotes.length - 1]
                    .author ??
                '',
          ),
        ),
      );
      final path = (await getApplicationDocumentsDirectory()).path;
      File imgFile = await File('$path/screenshot.jpeg').create();
      imgFile.writeAsBytes(image);
      XFile file = XFile(imgFile.path);
      await Share.shareXFiles([file]);
    } catch (e) {
      print('error aave chhe 3: ${e.toString()}');
      emit(
        state.copyWith(status: QuoteStateStatus.error),
      );
    }
  }

  Future<void> _shareAsText(
      ShareAsTextEvent event, Emitter<QuoteDataState> emit) async {
    try {
      await Share.share(
        '"${state.listOfQuotes[state.currentIndex ?? state.listOfQuotes.length - 1].quote}" - ${state.listOfQuotes[state.currentIndex ?? state.listOfQuotes.length - 1].author}',
      );
    } catch (e) {
      print('error aave chhe 4 : ${e.toString()}');
      emit(
        state.copyWith(status: QuoteStateStatus.error),
      );
    }
  }

  Future<void> _copyQuoteToClipboard(
      CopyQuoteToClipBoardEvent event, Emitter<QuoteDataState> emit) async {
    try {
      await Clipboard.setData(
        ClipboardData(
          text:
              '"${state.listOfQuotes[state.currentIndex ?? state.listOfQuotes.length - 1].quote}" - ${state.listOfQuotes[state.currentIndex ?? state.listOfQuotes.length - 1].author}',
        ),
      );
      emit(state.copyWith(
        status: QuoteStateStatus.copiedSuccessfully,
      ));
    } catch (e) {
      print('error aave chhe 5: ${e.toString()}');
      state.copyWith(status: QuoteStateStatus.error);
    }
  }

  void _setCurrentIndex(
      CurrentIndexChangeEvent event, Emitter<QuoteDataState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }

  Future<void> _fetchListOfFavouriteQuote(FetchListOfFavouriteQuoteEvent event,
      Emitter<QuoteDataState> emit) async {
    try {
      emit(state.copyWith(status: QuoteStateStatus.loading));
      final userReference = db.collection('users').doc(currentUserUid);
      final quoteReference = db.collection('motivational_quotes');
      final docSnapshot = await userReference.get();
      final listOfDocID = docSnapshot.data()?['favourite_quote_id'];
      final List<Quotes> quoteList = [];
      if (listOfDocID != null) {
        for (String docID in listOfDocID) {
          final snapshot = await quoteReference.doc(docID).get();
          quoteList.add(Quotes.fromFireStore(snapshot.data() ?? {}));
        }
      }
      emit(
        state.copyWith(
          status: QuoteStateStatus.favouriteListLoaded,
          listOfFavouriteQuotes: quoteList,
        ),
      );
    } catch (e) {
      print('error aave chhe 6: ${e.toString()}');
      emit(state.copyWith(status: QuoteStateStatus.error));
    }
  }

  Future<void> _addToFavourite(
      AddToFavouriteEvent event, Emitter<QuoteDataState> emit) async {
    try {
      await db.collection('users').doc(currentUserUid).update(
        {
          'favourite_quote_id': FieldValue.arrayUnion(
            [event.docID],
          ),
        },
      );
      add(const FetchListOfFavouriteQuoteEvent());
    } catch (e) {
      print('error aave chhe 7: ${e.toString()}');
      emit(state.copyWith(status: QuoteStateStatus.error));
    }
  }

  Future<void> _removeFromFavourite(
      RemoveFromFavouriteEvent event, Emitter<QuoteDataState> emit) async {
    try {
      await db.collection('users').doc(currentUserUid).update(
        {
          'favourite_quote_id': FieldValue.arrayRemove(
            [event.docID],
          ),
        },
      );
      add(const FetchListOfFavouriteQuoteEvent());
    } catch (e) {
      print('error aave chhe 8: ${e.toString()}');
      emit(state.copyWith(status: QuoteStateStatus.error));
    }
  }

  Future<void> _handleBookMark(
      HandleBookMarkEvent event, Emitter<QuoteDataState> emit) async {
    try {
      final docID = event.quote.docID;
      final reference = db.collection('users').doc(currentUserUid);
      final snapshot = await reference.get();
      final docIdList = snapshot.data()?['favourite_quote_id'];
      if (docIdList != null) {
        if (docIdList.contains(docID)) {
          add(RemoveFromFavouriteEvent(docID: docID!));
        } else {
          add(AddToFavouriteEvent(docID: docID!));
        }
      } else {
        add(AddToFavouriteEvent(docID: docID!));
      }
    } catch (e) {
      print('error aave chhe 9: ${e.toString()}');
      emit(state.copyWith(status: QuoteStateStatus.error));
    }
  }

  Future<void> _fetchBookmarkInfo(
      FetchBookmarkInfoEvent event, Emitter<QuoteDataState> emit) async {
    final userReference = db.collection('users').doc(currentUserUid);
    final docSnapshot = await userReference.get();
    final listOfDocID =
        docSnapshot.data()?['favourite_quote_id'] as List<dynamic>?;
    emit(state.copyWith(listOfFavQuoteIds: listOfDocID));
  }
}
