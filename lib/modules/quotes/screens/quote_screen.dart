import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/admin_quote_list/screens/admin_quote_list_screen.dart';
import 'package:quotes_app/modules/create_quote/screens/create_quote_screen.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuoteDataBloc, QuoteDataState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == QuoteStateStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Be what you want to be'),
          backgroundColor: Colors.blueAccent.shade100,
        ),
        endDrawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue.shade100),
                child: null,
              ),
              ListTile(
                leading: const Icon(Icons.file_copy_outlined),
                title: const Text('My Quotes'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminQuoteListScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        body: BlocBuilder<QuoteDataBloc, QuoteDataState>(
          builder: (context, state) {
            if (state.status == QuoteStateStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == QuoteStateStatus.loaded) {
              final randomInt = random.nextInt(state.listOfQuotes.length);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.listOfQuotes[randomInt].quote ?? '',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '- ${state.listOfQuotes[randomInt].author}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 30),
                      if (state.user.isAdmin!)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade100),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const CreateQuoteScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Create Quotes',
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('No data'),
              );
            }
          },
        ),
      ),
    );
  }
}
