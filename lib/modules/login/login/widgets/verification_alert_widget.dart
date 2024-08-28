import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/login/login/bloc/login_bloc.dart';

class VerificationAlertWidget extends StatelessWidget {
  const VerificationAlertWidget(
      {super.key,
      required this.onClosedTap,
      required this.onResendEmailVerificationTap});

  final VoidCallback onClosedTap;
  final VoidCallback onResendEmailVerificationTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(
          'You have not verified your email yet,Please verify your email.'),
      actions: [
        BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return TextButton(
              onPressed: () {
                onResendEmailVerificationTap();
                onClosedTap();
              },
              child: const Text('Resend email'),
            );
          },
        ),
        TextButton(
          onPressed: onClosedTap,
          child: const Text('Okay'),
        )
      ],
    );
  }
}
