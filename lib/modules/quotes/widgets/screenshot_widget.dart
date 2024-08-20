import 'package:flutter/material.dart';

class ScreenshotWidget extends StatelessWidget {
  const ScreenshotWidget(
      {super.key, required this.quote, required this.author});

  final String quote;
  final String author;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            quote,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Text(
            '- $author',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ],
      ),
    );
  }
}
