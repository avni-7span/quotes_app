import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/colors.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';
import 'package:quotes_app/core/widgets/custom_elevated_button.dart';
import 'package:quotes_app/core/widgets/list_view_card.dart';
import 'package:quotes_app/modules/home/bloc/quote_data_bloc.dart';

@RoutePage()
class FavouriteQuoteScreen extends StatefulWidget implements AutoRouteWrapper {
  const FavouriteQuoteScreen({super.key});

  @override
  State<FavouriteQuoteScreen> createState() => _FavouriteQuoteScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => QuoteBloc()
        ..add(
          const FetchListOfFavouriteQuoteEvent(),
        ),
      child: this,
    );
  }
}

class _FavouriteQuoteScreenState extends State<FavouriteQuoteScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<QuoteBloc, QuoteState>(
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
            onPressed: () async {
              await context.router
                  .replaceAll([const HomeRoute()], updateExistingRoutes: false);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: ColorPallet.lotusPink,
        ),
        body: BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, state) {
            if (state.status == QuoteStateStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == QuoteStateStatus.loaded &&
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
                  return ListViewCard(
                    quote: state.favouriteQuoteList[index].quote,
                    author: state.favouriteQuoteList[index].author ?? '',
                    crudButtonWidget: CustomElevatedButton(
                        onPressed: () {
                          context.read<QuoteBloc>().add(
                              RemoveQuoteFromFavouriteList(
                                  docID:
                                      state.favouriteQuoteList[index].docID));
                        },
                        buttonLabel: 'Remove From Favourite'),
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'Could not load list',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
