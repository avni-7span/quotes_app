import 'package:flutter/material.dart';
import 'package:quotes_app/core/widgets/custom_elevated_button.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.quote,
    required this.author,
  });

  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final String quote;
  final String author;

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
              author,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomElevatedButton(
                  onPressed: onEditPressed,
                  buttonLabel: 'Edit quote',
                ),
                CustomElevatedButton(
                  onPressed: onDeletePressed,
                  buttonLabel: 'Delete quote',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
