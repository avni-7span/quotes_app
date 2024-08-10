import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/firebase_options.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';
import 'package:quotes_app/modules/quotes/screens/quote_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuoteDataBloc()..add(const FetchQuoteDataEvent()),
      child: const MaterialApp(
        home: QuoteScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
