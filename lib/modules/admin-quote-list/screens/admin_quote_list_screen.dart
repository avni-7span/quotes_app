import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/colors.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';
import 'package:quotes_app/modules/admin-quote-list/bloc/admin_quote_bloc.dart';
import 'package:quotes_app/modules/admin-quote-list/widgets/delete_alert_dialogue.dart';
import 'package:quotes_app/modules/admin-quote-list/widgets/update_bottom_sheet_widget.dart';

@RoutePage()
class AdminQuoteListScreen extends StatefulWidget implements AutoRouteWrapper {
  const AdminQuoteListScreen({super.key});

  @override
  State<AdminQuoteListScreen> createState() => _AdminQuoteListScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminBloc()
        ..add(
          const FetchAdminQuoteListEvent(),
        ),
      child: this,
    );
  }
}

class _AdminQuoteListScreenState extends State<AdminQuoteListScreen> {
  Future<void> showQuoteUpdateBottomSheet({
    required String docID,
    required String quote,
    required String author,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => UpdateBottomSheetWidget(
        quote: quote,
        author: author,
        onUpdateTap: ({
          required updatedAuthor,
          required updatedQuote,
        }) {
          context.read<AdminBloc>().add(
                EditQuoteEvent(
                  docID: docID,
                  quote: updatedQuote,
                  author: updatedAuthor,
                ),
              );
          // TODO
          // ..add(const FetchAdminQuoteListEvent());
          ctx.maybePop();
        },
      ),
    );
  }

  void showDeleteQuoteAlertDialogue({required String quoteDocId}) {
    showDialog(
      context: context,
      builder: (_) => DeleteAlertDialogue(
        onDeleteTap: () {
          context
              .read<AdminBloc>()
              .add(DeleteQuoteEvent(quoteDocId: quoteDocId));
          context.maybePop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallet.blurGreen,
      appBar: AppBar(
        title: const Text(
          'My Quotes',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () => context.replaceRoute(const HomeRoute()),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: ColorPallet.lotusPink,
      ),
      body: BlocListener<AdminBloc, AdminQuoteState>(
        listener: (context, state) {
          if (state.status == AdminQuoteStateStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? '')),
            );
          }
        },
        child: BlocBuilder<AdminBloc, AdminQuoteState>(
          builder: (context, state) {
            if (state.status == AdminQuoteStateStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == AdminQuoteStateStatus.loaded &&
                state.adminQuoteList.isNotEmpty) {
              return Center(
                child: ListView.builder(
                  itemCount: state.adminQuoteList.length,
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
                              state.adminQuoteList[index].quote,
                              style: const TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '- ${state.adminQuoteList[index].author}',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () => showQuoteUpdateBottomSheet(
                                          docID:
                                              state.adminQuoteList[index].docID,
                                          quote:
                                              state.adminQuoteList[index].quote,
                                          author: state.adminQuoteList[index]
                                                  .author ??
                                              '',
                                        ),
                                    child: const Text('Edit quote')),
                                ElevatedButton(
                                    onPressed: () {
                                      showDeleteQuoteAlertDialogue(
                                        quoteDocId:
                                            state.adminQuoteList[index].docID,
                                      );
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
            } else {
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
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
