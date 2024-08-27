import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/colors.dart';
import 'package:quotes_app/core/constants/const_strings.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';
import 'package:quotes_app/modules/admin-quote-list/bloc/admin_quote_list_bloc.dart';
import 'package:quotes_app/modules/admin-quote-list/widgets/delete_alert_dialogue.dart';
import 'package:quotes_app/modules/admin-quote-list/widgets/update_bottom_sheet_widget.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';

@RoutePage()
class AdminQuoteListScreen extends StatefulWidget implements AutoRouteWrapper {
  const AdminQuoteListScreen({super.key});

  @override
  State<AdminQuoteListScreen> createState() => _AdminQuoteListScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AdminQuoteListBloc()..add(const FetchingAdminQuoteListEvent()),
      child: this,
    );
  }
}

class _AdminQuoteListScreenState extends State<AdminQuoteListScreen> {
  // void _showAlertDialogue(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text('Access Denied'),
  //       content: const Text(ConstantStrings.adminAdmin),
  //       actions: [
  //         TextButton(
  //           onPressed: context.maybePop,
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () {},
  //           child: const Text('Yes'),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Future _showBottomSheet(
      {required String docID,
      required String quote,
      required String author,
      required BuildContext quoteScreenContext}) {
    return showModalBottomSheet(
      context: quoteScreenContext,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<AdminQuoteListBloc>(quoteScreenContext),
        child: UpdateBottomSheetWidget(
          docID: docID,
          quote: quote,
          author: author,
          onClosedTap: () {
            context.maybePop();
          },
        ),
      ),
    );
  }

  void showAlertDialogue(
      {required BuildContext dialogueContext, required int index}) {
    showDialog(
      context: dialogueContext,
      builder: (_context) => BlocProvider.value(
        value: BlocProvider.of<AdminQuoteListBloc>(dialogueContext),
        child: DeleteAlertDialogue(index: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorPallet.blurGreen,
      appBar: AppBar(
        title: const Text(
          'My Quotes',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () => context.replaceRoute(const QuoteRoute()),
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: ColorPallet.lotusPink,
      ),
      body: BlocListener<AdminQuoteListBloc, AdminQuoteListState>(
        listener: (context, state) {
          if (state.status == AdminQuoteListStateStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? ''),
              ),
            );
          }
        },
        child: BlocBuilder<AdminQuoteListBloc, AdminQuoteListState>(
          builder: (context, state) {
            if (state.status == AdminQuoteListStateStatus.fetching) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == AdminQuoteListStateStatus.loaded &&
                state.listOfAdminQuotes.isNotEmpty) {
              return Center(
                child: ListView.builder(
                  itemCount: state.listOfAdminQuotes.length,
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
                              state.listOfAdminQuotes[index].quote ?? '',
                              style: const TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '- ${state.listOfAdminQuotes[index].author}',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () => _showBottomSheet(
                                        docID: state
                                            .listOfAdminQuotes[index].docID!,
                                        quote: state
                                            .listOfAdminQuotes[index].quote!,
                                        author: state.listOfAdminQuotes[index]
                                                .author ??
                                            '',
                                        quoteScreenContext: context),
                                    child: const Text('Edit quote')),
                                ElevatedButton(
                                    onPressed: () {
                                      showAlertDialogue(
                                          index: index,
                                          dialogueContext: context);
                                    },
                                    child: const Text('Delete quote'))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state.status == AdminQuoteListStateStatus.loaded &&
                state.listOfAdminQuotes.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You have not uploaded any quotes yet.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                      // SizedBox(height: 40),
                      // BlocBuilder<QuoteDataBloc, QuoteDataState>(
                      //   builder: (context, state) {
                      //     return ElevatedButton(
                      //       onPressed: () async {
                      //         if (state.user.isAdmin!) {
                      //           await context
                      //               .pushRoute(const CreateQuoteRoute());
                      //         } else {
                      //           _showAlertDialogue(context);
                      //         }
                      //       },
                      //       child: const Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Icon(Icons.add),
                      //           SizedBox(width: 10),
                      //           Text('Start adding quote')
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
