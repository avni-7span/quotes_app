import 'package:flutter/material.dart';

class ListViewCard extends StatelessWidget {
  const ListViewCard({
    super.key,
    required this.quote,
    required this.author,
    required this.crudButtonWidget,
  });

  final String quote;
  final String author;
  final Widget crudButtonWidget;

  @override
  Widget build(BuildContext context) {
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
              quote,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '- $author',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            crudButtonWidget
          ],
        ),
      ),
    );
  }
}
