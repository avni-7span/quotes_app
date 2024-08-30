import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/authentication-repository/authentication_repository.dart';
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
  final currentUser = AuthenticationRepository.instance.currentUser;

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.only(top: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      shrinkWrap: true,
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
                      const CopyQuoteToClipboardEvent(),
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
      ],
    );
  }
}
