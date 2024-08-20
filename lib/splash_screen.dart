import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkRoute();
  }

  Future<void> checkRoute() async {
    await Future.delayed(const Duration(seconds: 3));
    await context.replaceRoute(const QuoteRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/quote_pic.png',
          height: 100,
        ),
      ),
    );
  }
}
