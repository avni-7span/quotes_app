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

  Icon iconData(listOfFavID, docId) {
    if (listOfFavID == null) {
      return const Icon(Icons.bookmark_outline);
    } else {
      if (listOfFavID.contains(docId)) {
        return const Icon(Icons.bookmark);
      } else {
        return const Icon(Icons.bookmark_outline);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () =>
                  context.read<QuoteDataBloc>().add(const ShareAsTextEvent()),
              icon: const Icon(Icons.share),
            ),
            const Text(
              'Share as text',
              maxLines: 2,
            )
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => context.read<QuoteDataBloc>().add(
                    TakeScreenShotAndShareEvent(
                        screenshotController: widget._screenshotController),
                  ),
              icon: const Icon(Icons.send),
            ),
            const Text(
              'Share as image',
              maxLines: 2,
            )
          ],
        ),
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
        BlocBuilder<QuoteDataBloc, QuoteDataState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      final quoteToHandle = state.quoteList[
                          state.currentIndex ?? state.quoteList.length - 1];
                      context
                          .read<QuoteDataBloc>()
                          .add(HandleBookMarkEvent(quote: quoteToHandle));
                    },
                    icon: const Icon(Icons.book_outlined)),
                const Text(
                  'Favourite',
                  maxLines: 2,
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
