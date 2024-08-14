import 'package:flutter/material.dart';

class CreateQuoteScreen extends StatelessWidget {
  const CreateQuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter the Quote',
                style: TextStyle(
                    color: Colors.purple.shade100,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              Text(
                'Enter Author Name',
                style: TextStyle(
                    color: Colors.purple.shade100,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Create Quote'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
