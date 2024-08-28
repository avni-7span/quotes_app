import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/const_strings.dart';
import 'package:quotes_app/modules/admin-quote-list/bloc/admin_quote_list_bloc.dart';

class DeleteAlertDialogue extends StatelessWidget {
  const DeleteAlertDialogue({super.key, required this.onDeleteTap});

  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(ConstantStrings.quoteDeleteAlert),
      actions: [
        TextButton(
          onPressed: context.maybePop,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onDeleteTap,
          child: const Text('Yes'),
        )
      ],
    );
  }
}
