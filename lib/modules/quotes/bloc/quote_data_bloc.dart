import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotes_app/core/model/quote-data-model/quotes_data_model.dart';
import 'package:quotes_app/core/model/user-model/user_model.dart';
import 'package:quotes_app/modules/quotes/widgets/screenshot_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

part 'quote_data_event.dart';

part 'quote_data_state.dart';

final fireStoreInstance = FirebaseFirestore.instance;
final firebaseAuth = firebase_auth.FirebaseAuth.instance;
final random = Random();

class QuoteDataBloc extends Bloc<QuoteDataEvent, QuoteDataState> {
  QuoteDataBloc() : super(const QuoteDataState()) {
    on<FetchQuoteDataEvent>(fetchQuoteData);
    on<FetchAdminDetailEvent>(fetchAdminDetails);
    on<TakeScreenShotAndShareEvent>(takeScreenShotAndShare);
    on<ShareAsTextEvent>(shareAsText);
    on<CopyQuoteToClipBoardEvent>(copyQuoteToClipboard);
  }

  Future<void> fetchQuoteData(
    FetchQuoteDataEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      emit(state.copyWith(status: QuoteStateStatus.loading));
      final querySnapShot =
          await fireStoreInstance.collection('motivational_quotes').get();
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
      emit(state.copyWith(status: QuoteStateStatus.error));
    }
  }

  Future<void> fetchAdminDetails(
      FetchAdminDetailEvent event, Emitter<QuoteDataState> emit) async {
    try {
      emit(state.copyWith(status: QuoteStateStatus.loading));
      final docSnapShot = await fireStoreInstance
          .collection('users')
          .doc(firebaseAuth.currentUser?.uid)
          .get();
      final user = User.fromFireStore(docSnapShot);
      emit(state.copyWith(status: QuoteStateStatus.adminFetched, user: user));
    } catch (e) {
      emit(state.copyWith(status: QuoteStateStatus.error));
    }
  }

  Future<void> takeScreenShotAndShare(
    TakeScreenShotAndShareEvent event,
    Emitter<QuoteDataState> emit,
  ) async {
    try {
      final image = await event.screenshotController.captureFromWidget(
        pixelRatio: 2.0,
        Material(
          child: ScreenshotWidget(
            quote: state.listOfQuotes[event.index].quote ?? '',
            author: state.listOfQuotes[event.index].author ?? '',
          ),
        ),
      );
      final path = (await getApplicationDocumentsDirectory()).path;
      File imgFile = await File('$path/screenshot.jpeg').create();
      imgFile.writeAsBytes(image);
      XFile file = XFile(imgFile.path);
      await Share.shareXFiles([file]);
    } catch (e) {
      emit(
        state.copyWith(status: QuoteStateStatus.error),
      );
    }
  }

  Future<void> shareAsText(
      ShareAsTextEvent event, Emitter<QuoteDataState> emit) async {
    try {
      await Share.share(
        '\"${state.listOfQuotes[event.index].quote}\" - ${state.listOfQuotes[event.index].author}',
      );
    } catch (e) {
      emit(
        state.copyWith(status: QuoteStateStatus.error),
      );
    }
  }

  Future<void> copyQuoteToClipboard(
      CopyQuoteToClipBoardEvent event, Emitter<QuoteDataState> emit) async {
    try {
      await Clipboard.setData(
        ClipboardData(
          text:
              '\"${state.listOfQuotes[event.index].quote}\" - ${state.listOfQuotes[event.index].author}',
        ),
      );
      if (ClipboardStatus == ClipboardStatus.pasteable) {
        emit(state.copyWith(status: QuoteStateStatus.copiedSuccessfully));
      } else {
        emit(state.copyWith(status: QuoteStateStatus.error));
      }
    } catch (e) {
      state.copyWith(status: QuoteStateStatus.error);
    }
  }
}
