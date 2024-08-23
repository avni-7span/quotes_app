import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/colors.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';
import 'package:quotes_app/core/widgets/custom_material_button.dart';
import 'package:quotes_app/modules/create-quote/bloc/admin_quote_bloc.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';

@RoutePage()
class CreateQuoteScreen extends StatefulWidget {
  const CreateQuoteScreen({super.key});

  @override
  State<CreateQuoteScreen> createState() => _CreateQuoteScreenState();
}

class _CreateQuoteScreenState extends State<CreateQuoteScreen> {
  final TextEditingController _authorFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminQuoteBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Quote'),
          backgroundColor: ColorPallet.fadeBrown,
        ),
        body: BlocListener<AdminQuoteBloc, AdminQuoteState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) async {
            if (state.status == AdminQuoteStateStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Something went wrong'),
                ),
              );
            } else if (state.status == AdminQuoteStateStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quote added successfully'),
                ),
              );
              await context.router.replace(const QuoteRoute());
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: BlocBuilder<AdminQuoteBloc, AdminQuoteState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        const Text(
                          'Share your creative quotes with other users.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          onChanged: (value) =>
                              context.read<AdminQuoteBloc>().add(
                                    QuoteFieldChangeEvent(value),
                                  ),
                          decoration: InputDecoration(
                              labelText: 'Quote',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              errorText: state.quote.displayError != null
                                  ? 'Quote is required.'
                                  : null),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _authorFieldController,
                          decoration: InputDecoration(
                            labelText: 'Author Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        CustomMaterialButton(
                          onPressed: () {
                            context.read<AdminQuoteBloc>().add(
                                  AddQuoteToFireStoreEvent(
                                      author: _authorFieldController.text),
                                );
                            context
                                .read<QuoteDataBloc>()
                                .add(const FetchQuoteDataEvent());
                          },
                          buttonLabelWidget:
                              state.status == AdminQuoteStateStatus.addQuote
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Create Quote',
                                      style: TextStyle(fontSize: 20),
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
        ),
      ),
    );
  }
}
