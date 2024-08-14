import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/create_quote/bloc/admin_quote_bloc.dart';
import 'package:quotes_app/modules/quotes/screens/quote_screen.dart';

class CreateQuoteScreen extends StatefulWidget {
  const CreateQuoteScreen({super.key});

  @override
  State<CreateQuoteScreen> createState() => _CreateQuoteScreenState();
}

class _CreateQuoteScreenState extends State<CreateQuoteScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminQuoteBloc(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: BlocListener<AdminQuoteBloc, AdminQuoteState>(
              listener: (context, state) {
                if (state.status == AdminQuoteStateStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Something went wrong'),
                    ),
                  );
                  return;
                }
                if (state.status == AdminQuoteStateStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Quote added successfully'),
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuoteScreen(),
                    ),
                  );
                }
              },
              child: BlocBuilder<AdminQuoteBloc, AdminQuoteState>(
                builder: (context, state) {
                  return Column(
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
                        onChanged: (value) =>
                            context.read<AdminQuoteBloc>().add(
                                  QuoteFieldChangeEvent(value),
                                ),
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            errorText: state.quote.displayError != null
                                ? 'Invalid Name'
                                : null),
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
                        onChanged: (value) =>
                            context.read<AdminQuoteBloc>().add(
                                  AuthorFieldChangeEvent(value),
                                ),
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            errorText: state.author.displayError != null
                                ? 'Invalid Name'
                                : null),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<AdminQuoteBloc>()
                              .add(const AddQuoteToFireStoreEvent());
                        },
                        child: state.status == AdminQuoteStateStatus.addQuote
                            ? const CircularProgressIndicator()
                            : const Text('Create Quote'),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
