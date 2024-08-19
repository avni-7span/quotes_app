import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/colors/colors.dart';
import 'package:quotes_app/core/routes/router.gr.dart';
import 'package:quotes_app/modules/create_quote/bloc/admin_quote_bloc.dart';

@RoutePage()
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
        appBar: AppBar(
          backgroundColor: ColorPallet.fadeBrown,
        ),
        body: BlocListener<AdminQuoteBloc, AdminQuoteState>(
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
              context.router.replace(const QuoteRoute());
            }
          },
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: BlocBuilder<AdminQuoteBloc, AdminQuoteState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Share your creative quotes with other users.',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    const Text(
                      'Quote',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      onChanged: (value) => context.read<AdminQuoteBloc>().add(
                            QuoteFieldChangeEvent(value),
                          ),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          errorText: state.quote.displayError != null
                              ? 'Invalid Name'
                              : null),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Author Name',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      onChanged: (value) => context.read<AdminQuoteBloc>().add(
                            AuthorFieldChangeEvent(value),
                          ),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          errorText: state.author.displayError != null
                              ? 'Invalid Name'
                              : null),
                    ),
                    const Spacer(),
                    MaterialButton(
                      color: Colors.black,
                      onPressed: () {
                        context
                            .read<AdminQuoteBloc>()
                            .add(const AddQuoteToFireStoreEvent());
                      },
                      child: state.status == AdminQuoteStateStatus.addQuote
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Create Quote',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                    ),
                    const SizedBox(height: 50)
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
