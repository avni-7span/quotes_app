import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotes_app/core/authentication-repository/authentication_repository.dart';
import 'package:quotes_app/core/model/quote-data-model/quotes_model.dart';
import 'package:quotes_app/core/model/user-model/user_model.dart';
import 'package:quotes_app/modules/home/widgets/screenshot_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

part 'quote_data_event.dart';

part 'quote_data_state.dart';

final db = FirebaseFirestore.instance;
final firebaseAuthInstance = firebase_auth.FirebaseAuth.instance;

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  QuoteBloc() : super(const QuoteState()) {
    on<FetchQuoteDataEvent>(_fetchQuoteData);
    on<FetchAdminDetailEvent>(_fetchAdminDetails);
    on<TakeScreenShotAndShareEvent>(_takeScreenShotAndShare);
    on<ShareAsTextEvent>(_shareAsText);
    on<CopyQuoteToClipboardEvent>(_copyQuoteToClipboard);
    on<CurrentIndexChangeEvent>(_setCurrentIndex);
    on<FetchListOfFavouriteQuoteEvent>(_fetchListOfFavouriteQuote);
    on<HandleBookmarkEvent>(_handleBookMark);
    on<RemoveQuoteFromFavouriteList>(_removeQuoteFromFavouriteList);
  }

  Future<void> _fetchQuoteData(
    FetchQuoteDataEvent event,
    Emitter<QuoteState> emit,
  ) async {
    try {
      emit(state.copyWith(apiStatus: APIStatus.loading));

      final quoteDocSnapShot = await db.collection('motivational_quotes').get();
      final shuffledQuoteList = quoteDocSnapShot.docs
          .map(
            (e) => QuoteModel.fromFireStore(e.data()),
          )
          .toList()
        ..shuffle();

      emit(
        state.copyWith(
          apiStatus: APIStatus.loaded,
          quoteList: shuffledQuoteList,
        ),
      );
    } catch (e) {
      emit(state.copyWith(apiStatus: APIStatus.error));
    }
  }

  Future<void> _fetchAdminDetails(
    FetchAdminDetailEvent event,
    Emitter<QuoteState> emit,
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
    Emitter<QuoteState> emit,
  ) async {
    try {
      final image = await event.screenshotController.captureFromWidget(
        pixelRatio: 2.0,
        Material(
          child: ScreenshotWidget(
            quote: state.quoteList[state.currentIndex].quote,
            author: state.quoteList[state.currentIndex].author ?? '',
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
    Emitter<QuoteState> emit,
  ) async {
    try {
      await Share.share(
        '"${state.quoteList[state.currentIndex].quote}" - ${state.quoteList[state.currentIndex].author}',
      );
    } catch (e) {
      emit(
        state.copyWith(apiStatus: APIStatus.error),
      );
    }
  }

  Future<void> _copyQuoteToClipboard(
    CopyQuoteToClipboardEvent event,
    Emitter<QuoteState> emit,
  ) async {
    try {
      await Clipboard.setData(
        ClipboardData(
          text:
              '"${state.quoteList[state.currentIndex].quote}" - ${state.quoteList[state.currentIndex].author}',
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
      CurrentIndexChangeEvent event, Emitter<QuoteState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }

  Future<void> _fetchListOfFavouriteQuote(
    FetchListOfFavouriteQuoteEvent event,
    Emitter<QuoteState> emit,
  ) async {
    try {
      emit(state.copyWith(status: QuoteStateStatus.loading));
      final currentUserUid = AuthenticationRepository.instance.currentUser?.uid;
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

  Future<void> removeFromFavouriteList({
    required String? currentUserUid,
    required String quoteDocId,
  }) async {
    final userDocumentReference = db.collection('users').doc(currentUserUid);
    await userDocumentReference.update(
      {
        'favourite_quote_id': FieldValue.arrayRemove(
          [quoteDocId],
        ),
      },
    );
  }

  Future<void> addToFavouriteList({
    required String? currentUserUid,
    required String quoteDocId,
  }) async {
    final userDocumentReference = db.collection('users').doc(currentUserUid);
    await userDocumentReference.update(
      {
        'favourite_quote_id': FieldValue.arrayUnion(
          [quoteDocId],
        ),
      },
    );
  }

  Future<void> _handleBookMark(
    HandleBookmarkEvent event,
    Emitter<QuoteState> emit,
  ) async {
    try {
      final currentUserUid = AuthenticationRepository.instance.currentUser?.uid;
      final userDocumentReference = db.collection('users').doc(currentUserUid);
      final userDocSnapshot = await userDocumentReference.get();
      final favouriteQuoteDocIdList =
          userDocSnapshot.data()?['favourite_quote_id'];
      final quoteDocId = state.quoteList[state.currentIndex].docID;
      if (favouriteQuoteDocIdList != null) {
        if (favouriteQuoteDocIdList.contains(quoteDocId)) {
          /// remove quote from list of favourites
          await removeFromFavouriteList(
            currentUserUid: currentUserUid,
            quoteDocId: quoteDocId,
          );
          add(const FetchListOfFavouriteQuoteEvent());
        } else {
          /// add quote to list of favourites
          await addToFavouriteList(
            currentUserUid: currentUserUid,
            quoteDocId: quoteDocId,
          );
          add(const FetchListOfFavouriteQuoteEvent());
        }
      } else {
        /// remove quote from list of favourites
        await addToFavouriteList(
          currentUserUid: currentUserUid,
          quoteDocId: quoteDocId,
        );
        add(const FetchListOfFavouriteQuoteEvent());
      }
    } catch (e) {
      emit(state.copyWith(apiStatus: APIStatus.error));
    }
  }

  Future<void> _removeQuoteFromFavouriteList(
    RemoveQuoteFromFavouriteList event,
    Emitter<QuoteState> emit,
  ) async {
    final currentUserUid = AuthenticationRepository.instance.currentUser?.uid;
    await removeFromFavouriteList(
        currentUserUid: currentUserUid, quoteDocId: event.docID);
    add(const FetchListOfFavouriteQuoteEvent());
  }
}
