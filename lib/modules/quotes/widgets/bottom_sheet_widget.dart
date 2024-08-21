import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';
import 'package:screenshot/screenshot.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    super.key,
    required this.screenshotController,
    required this.onClosedTap,
  });

  final ScreenshotController screenshotController;
  final VoidCallback onClosedTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: BlocProvider(
        create: (context) => QuoteDataBloc(),
        child: ListView(
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
                const Text('Share as text')
              ],
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () => context.read<QuoteDataBloc>().add(
                          TakeScreenShotAndShareEvent(
                              screenshotController: screenshotController),
                        ),
                    icon: const Icon(Icons.send)),
                const Text('Share as image')
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
                      context
                          .read<QuoteDataBloc>()
                          .add(const FetchQuoteDataEvent());
                      onClosedTap();
                    },
                    icon: const Icon(Icons.copy)),
                const Text('Copy Quote')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
