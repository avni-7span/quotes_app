import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/core/constants/const_strings.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';

@RoutePage()
class VerificationWaitingScreen extends StatefulWidget {
  const VerificationWaitingScreen({super.key});

  @override
  State<VerificationWaitingScreen> createState() =>
      _VerificationWaitingScreenState();
}

class _VerificationWaitingScreenState extends State<VerificationWaitingScreen> {
  @override
  void initState() {
    super.initState();
    checkRoute();
  }

  Future<void> checkRoute() async {
    await Future.delayed(const Duration(seconds: 6));
    await context.replaceRoute(const LoginRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/check.png', height: 200),
              const SizedBox(height: 30),
              const Text(
                textAlign: TextAlign.center,
                ConstantStrings.verificationGuide,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
