import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/model/quote-data-model/quotes_model.dart';
import 'package:quotes_app/modules/home/bloc/quote_data_bloc.dart';
import 'package:quotes_app/modules/home/widgets/custom_container_quote_card.dart';

class QuoteCard extends StatefulWidget {
  const QuoteCard({super.key, required this.index});

  final int index;

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  bool _checkIsFavourite({
    required List<QuoteModel> favQuoteList,
    required String currentQuoteDocId,
  }) {
    List<String> list = [];
    for (QuoteModel quote in favQuoteList) {
      list.add(quote.docID);
    }
    if (list.contains(currentQuoteDocId)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuoteBloc, QuoteState>(
      builder: (context, state) {
        if (state.apiStatus == APIStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.apiStatus == APIStatus.loaded) {
          return CustomContainerQuoteCard(
            quote: state.quoteList[widget.index].quote,
            author: '- ${state.quoteList[widget.index].author}',
            isFavourite: _checkIsFavourite(
              favQuoteList: state.favouriteQuoteList,
              currentQuoteDocId: state.quoteList[widget.index].docID,
            ),
            onBookmarkTap: () {
              context.read<QuoteBloc>().add(
                    const HandleBookmarkEvent(),
                  );
            },
          );
        } else {
          return const Center(
            child: Text(
              'Could Not Load Quotes!',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          );
        }
      },
    );
  }
}
