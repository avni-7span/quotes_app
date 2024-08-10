import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuoteDataBloc>().add(const FetchQuoteDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuoteDataBloc, QuoteDataState>(
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
        body: ListView.builder(
          itemCount: 11,
          itemBuilder: (context, index) {
            return BlocBuilder<QuoteDataBloc, QuoteDataState>(
              builder: (context, state) {
                return state.status == QuoteStateStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : state.status == QuoteStateStatus.loaded
                        ? ListTile(
                            title: Text(state.quote.quote!),
                            subtitle: Text(state.quote.author!),
                          )
                        : const SizedBox();
              },
            );
          },
        ),
      ),
    );
  }
}
