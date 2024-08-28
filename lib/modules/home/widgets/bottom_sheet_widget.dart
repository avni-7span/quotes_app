import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/home/bloc/quote_data_bloc.dart';
import 'package:screenshot/screenshot.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({
    super.key,
    required ScreenshotController screenshotController,
    required void Function() onClosedTap,
  })  : _onClosedTap = onClosedTap,
        _screenshotController = screenshotController;

  final ScreenshotController _screenshotController;
  final VoidCallback _onClosedTap;

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    checkIsFavourite(context.read<QuoteBloc>().state.currentIndex ??
        context.read<QuoteBloc>().state.quoteList.length - 1);
  }

  final db = FirebaseFirestore.instance;

  Future<void> checkIsFavourite(int currentIndex) async {
    final docId = context.read<QuoteBloc>().state.quoteList[currentIndex].docID;
    final userDocSnapshot =
        await db.collection('users').doc(currentUser?.uid).get();
    final idList = userDocSnapshot.data()?['favourite_quote_id'];
    if (idList == null) {
      setState(() {
        isFavourite = false;
      });
    } else {
      if (idList.contains(docId)) {
        setState(() {
          isFavourite = true;
        });
      } else {
        setState(() {
          isFavourite = false;
        });
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
                  context.read<QuoteBloc>().add(const ShareAsTextEvent()),
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
              onPressed: () => context.read<QuoteBloc>().add(
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
                context.read<QuoteBloc>().add(
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
        BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () async {
                      final quoteToHandle = state.quoteList[
                          state.currentIndex ?? state.quoteList.length - 1];
                      context
                          .read<QuoteBloc>()
                          .add(HandleBookMarkEvent(quote: quoteToHandle));
                      setState(() {
                        isFavourite = !isFavourite;
                      });
                    },
                    icon: isFavourite
                        ? const Icon(Icons.bookmark)
                        : const Icon(Icons.bookmark_outline)),
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
