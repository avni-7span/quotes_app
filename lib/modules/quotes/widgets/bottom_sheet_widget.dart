import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';
import 'package:screenshot/screenshot.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({
    super.key,
    required ScreenshotController screenshotController,
    required void Function() onClosedTap,
    // required bool isFavourite,
  })  : _onClosedTap = onClosedTap,
        _screenshotController = screenshotController;

  final ScreenshotController _screenshotController;
  final VoidCallback _onClosedTap;

  // final bool isFavourite = false;

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  // bool isBookMarked = false;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // isBookMarked = widget.isFavourite;
  }

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        scrollDirection: Axis.horizontal,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () => context
                      .read<QuoteDataBloc>()
                      .add(const ShareAsTextEvent()),
                  icon: const Icon(Icons.share)),
              const Text(
                'Share as text',
                maxLines: 2,
              )
            ],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () => context.read<QuoteDataBloc>().add(
                        TakeScreenShotAndShareEvent(
                            screenshotController: widget._screenshotController),
                      ),
                  icon: const Icon(Icons.send)),
              const Text(
                'Share as image',
                maxLines: 2,
              )
            ],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  context.read<QuoteDataBloc>().add(
                        const CopyQuoteToClipBoardEvent(),
                      );
                  widget._onClosedTap();
                },
                icon: const Icon(Icons.copy),
              ),
              const Text(
                'Copy Quote',
                maxLines: 2,
              )
            ],
          ),
          const SizedBox(width: 20),
          BlocBuilder<QuoteDataBloc, QuoteDataState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder(
                      stream: db.collection('motivational_quotes').snapshots(),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs;
                        return IconButton(
                          onPressed: () {
                            final quoteToHandle = state.listOfQuotes[
                                state.currentIndex ??
                                    state.listOfQuotes.length - 1];
                            context
                                .read<QuoteDataBloc>()
                                .add(HandleBookMarkEvent(quote: quoteToHandle));
                          },
                          icon: true
                              ? const Icon(Icons.bookmark)
                              : const Icon(Icons.bookmark_outline),
                        );
                      }),
                  const Text(
                    'Favourite',
                    maxLines: 2,
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
