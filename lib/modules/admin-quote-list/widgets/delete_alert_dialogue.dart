import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/admin-quote-list/bloc/admin_quote_list_bloc.dart';

class DeleteAlertDialogue extends StatelessWidget {
  const DeleteAlertDialogue({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Are you sure you want to delete this quote?'),
      actions: [
        TextButton(
          onPressed: context.maybePop,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final docId = context
                .read<AdminQuoteListBloc>()
                .state
                .listOfAdminQuotes[index]
                .docID;
            context.read<AdminQuoteListBloc>().add(
                  DeleteQuoteEvent(docID: docId!
                      // docID: state.listOfAdminQuotes[index].docID!,
                      ),
                );
            context.maybePop();
          },
          child: const Text('Yes'),
        )
      ],
    );
  }
}
