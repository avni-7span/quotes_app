import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';

class QuoteCard extends StatefulWidget {
  const QuoteCard({super.key, required this.index});

  final int index;

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<QuoteDataBloc, QuoteDataState>(
      builder: (context, state) {
        if (state.status == QuoteStateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == QuoteStateStatus.loaded ||
            state.status == QuoteStateStatus.copiedSuccessfully) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            height: size.height - 200,
            width: size.width - 40,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/quote.png',
                      height: 70,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      state.listOfQuotes[widget.index].quote ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      '- ${state.listOfQuotes[widget.index].author}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // return const Center(child: Text('Could Not Fetch Data.'));
          return ElevatedButton(
              onPressed: () => context
                  .read<QuoteDataBloc>()
                  .add(const FetchQuoteDataEvent()),
              child: const Text('Refresh'));
        }
      },
    );
  }
}
