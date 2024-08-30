import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/const_strings.dart';
import 'package:quotes_app/modules/auth/logout/bloc/logout_bloc.dart';

class LogoutAlertDialogue extends StatelessWidget {
  const LogoutAlertDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(ConstantStrings.logOutAlert),
      actions: [
        TextButton(
          onPressed: context.maybePop,
          child: const Text('Go Back'),
        ),
        TextButton(
          onPressed: () {
            context.read<LogoutBloc>().add(const LogoutEvent());
          },
          child: const Text('Logout'),
        )
      ],
    );
  }
}
