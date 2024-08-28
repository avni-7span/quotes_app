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
  }

  Future<void> _fetchQuoteData(
    FetchQuoteDataEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      emit(state.copyWith(apiStatus: APIStatus.loading));

      final quoteDocSnapShot = await db.collection('motivational_quotes').get();
      final quoteList = quoteDocSnapShot.docs
          .map(
            (e) => QuoteModel.fromFireStore(
              e.data(),
            ),
          )
          .toList()
        ..shuffle();

      emit(
        state.copyWith(
          apiStatus: APIStatus.loaded,
          quoteList: quoteList,
        ),
      );
    } catch (e) {
      emit(state.copyWith(apiStatus: APIStatus.error));
    }
  }

  Future<void> _fetchAdminDetails(
    FetchAdminDetailEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      emit(state.copyWith(apiStatus: APIStatus.loading));
      final currentUserUid = firebaseAuthInstance.currentUser?.uid;
      final userDocSnapshot =
          await db.collection('users').doc(currentUserUid).get();
      final user = UserModel.fromFireStore(userDocSnapshot);
      emit(state.copyWith(status: QuoteStateStatus.adminFetched, user: user));
    } catch (e) {
      emit(state.copyWith(apiStatus: APIStatus.error));
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
                .quoteList[state.currentIndex ?? state.quoteList.length - 1]
                .quote,
            author: state
                    .quoteList[state.currentIndex ?? state.quoteList.length - 1]
                    .author ??
                '',
          ),
        ),
      );
      final path = (await getApplicationDocumentsDirectory()).path;
      File imageFile = await File('$path/screenshot.jpeg').create();
      imageFile.writeAsBytes(image);
      XFile fileToShare = XFile(imageFile.path);
      await Share.shareXFiles([fileToShare]);
    } catch (e) {
      emit(
        state.copyWith(apiStatus: APIStatus.error),
      );
    }
  }

  Future<void> _shareAsText(
    ShareAsTextEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      await Share.share(
        '"${state.quoteList[state.currentIndex ?? state.quoteList.length - 1].quote}" - ${state.quoteList[state.currentIndex ?? state.quoteList.length - 1].author}',
      );
    } catch (e) {
      emit(
        state.copyWith(apiStatus: APIStatus.error),
      );
    }
  }

  Future<void> _copyQuoteToClipboard(
    CopyQuoteToClipBoardEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      await Clipboard.setData(
        ClipboardData(
          text:
              '"${state.quoteList[state.currentIndex ?? state.quoteList.length - 1].quote}" - ${state.quoteList[state.currentIndex ?? state.quoteList.length - 1].author}',
        ),
      );
      emit(state.copyWith(
        status: QuoteStateStatus.copiedSuccessfully,
      ));
    } catch (e) {
      state.copyWith(apiStatus: APIStatus.error);
    }
  }

  void _setCurrentIndex(
      CurrentIndexChangeEvent event, Emitter<QuoteDataState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }

  Future<void> _fetchListOfFavouriteQuote(
    FetchListOfFavouriteQuoteEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      emit(state.copyWith(status: QuoteStateStatus.loading));
      final currentUserUid = firebaseAuthInstance.currentUser?.uid;
      final userDocSnapshot =
          await db.collection('users').doc(currentUserUid).get();
      final quoteQuerySnapshot = db.collection('motivational_quotes');
      final favouriteQuoteDocIdList =
          userDocSnapshot.data()?['favourite_quote_id'];
      final List<QuoteModel> quoteList = [];
      if (favouriteQuoteDocIdList != null) {
        for (String docID in favouriteQuoteDocIdList) {
          final snapshot = await quoteQuerySnapshot.doc(docID).get();
          quoteList.add(QuoteModel.fromFireStore(snapshot.data() ?? {}));
        }
      }
      emit(
        state.copyWith(
          status: QuoteStateStatus.loaded,
          favouriteQuoteList: quoteList,
        ),
      );
    } catch (e) {
      emit(state.copyWith(apiStatus: APIStatus.error));
    }
  }

  Future<void> _addToFavourite(
    AddToFavouriteEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      final currentUserUid = firebaseAuthInstance.currentUser?.uid;
      await db.collection('users').doc(currentUserUid).update(
        {
          'favourite_quote_id': FieldValue.arrayUnion(
            [event.docID],
          ),
        },
      );
      add(const FetchListOfFavouriteQuoteEvent());
    } catch (e) {
      emit(state.copyWith(apiStatus: APIStatus.error));
    }
  }

  Future<void> _removeFromFavourite(
    RemoveFromFavouriteEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      final currentUserUid = firebaseAuthInstance.currentUser?.uid;

      await db.collection('users').doc(currentUserUid).update(
        {
          'favourite_quote_id': FieldValue.arrayRemove(
            [event.docID],
          ),
        },
      );
      add(const FetchListOfFavouriteQuoteEvent());
    } catch (e) {
      emit(state.copyWith(apiStatus: APIStatus.error));
    }
  }

  Future<void> _handleBookMark(
    HandleBookMarkEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      final currentUserUid = firebaseAuthInstance.currentUser?.uid;

      final userDocSnapshot =
          await db.collection('users').doc(currentUserUid).get();
      final favouriteQuoteDocIdList =
          userDocSnapshot.data()?['favourite_quote_id'];
      final quoteDocID = event.quote.docID;
      if (favouriteQuoteDocIdList != null) {
        if (favouriteQuoteDocIdList.contains(quoteDocID)) {
          add(RemoveFromFavouriteEvent(docID: quoteDocID));
        } else {
          add(AddToFavouriteEvent(docID: quoteDocID));
        }
      } else {
        add(AddToFavouriteEvent(docID: quoteDocID));
      }
    } catch (e) {
      emit(state.copyWith(apiStatus: APIStatus.error));
    }
  }
}
