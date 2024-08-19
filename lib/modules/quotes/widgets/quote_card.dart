import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';
import 'package:quotes_app/modules/quotes/widgets/bottom_sheet_widget.dart';
import 'package:screenshot/screenshot.dart';

class QuoteCard extends StatefulWidget {
  const QuoteCard({super.key, required this.index});

  final int index;

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  static final _screenShotController = ScreenshotController();

  Future _showBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheetWidget(
              screenshotController: _screenShotController, index: widget.index);
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      height: size.height - 200,
      width: size.width - 40,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(40)),
      child: BlocBuilder<QuoteDataBloc, QuoteDataState>(
        builder: (context, state) {
          if (state.status == QuoteStateStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == QuoteStateStatus.loaded) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      state.listOfQuotes[widget.index].quote ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      '- ${state.listOfQuotes[widget.index].author}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.bookmark_border_outlined,
                              color: Colors.white,
                              size: 30,
                            )),
                        const SizedBox(width: 30),
                        IconButton(
                          onPressed: _showBottomSheet,
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const Spacer()
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('No data'),
            );
          }
        },
      ),
    );
  }
}
