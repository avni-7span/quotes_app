import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/colors.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';

@RoutePage()
class BookmarkScreen extends StatefulWidget implements AutoRouteWrapper {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          QuoteDataBloc()..add(const FetchListOfFavouriteQuoteEvent()),
      child: this,
    );
  }
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<QuoteDataBloc, QuoteDataState>(
      listener: (context, state) {
        if (state.apiStatus == APIStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong.'),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorPallet.blurGreen,
        appBar: AppBar(
          title: const Text(
            'Favourite Quotes',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
              onPressed: () => context.replaceRoute(const QuoteRoute()),
              icon: const Icon(Icons.arrow_back)),
          backgroundColor: ColorPallet.lotusPink,
        ),
        body: BlocBuilder<QuoteDataBloc, QuoteDataState>(
          builder: (context, state) {
            if (state.status == QuoteStateStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.apiStatus == APIStatus.loaded &&
                state.favouriteQuoteList.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'You have not favourite any quotes yet.',
                    style: TextStyle(fontSize: 23),
                  ),
                ),
              );
            } else if (state.status == QuoteStateStatus.loaded &&
                state.favouriteQuoteList.isNotEmpty) {
              return ListView.builder(
                itemCount: state.favouriteQuoteList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(15),
                    shadowColor: Colors.black,
                    color: Colors.white,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.favouriteQuoteList[index].quote,
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '- ${state.favouriteQuoteList[index].author}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () {
                                final docID =
                                    state.favouriteQuoteList[index].docID;
                                context.read<QuoteDataBloc>().add(
                                      RemoveFromFavouriteEvent(docID: docID),
                                    );
                              },
                              child: const Text('remove from favourite'))
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                  child: Text(
                'Could not fetch data',
                style: TextStyle(fontSize: 20),
              ));
            }
          },
        ),
      ),
    );
  }
}
