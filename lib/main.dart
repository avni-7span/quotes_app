import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/firebase_options.dart';
import 'package:quotes_app/modules/login/bloc/login_bloc.dart';
import 'package:quotes_app/modules/login/screens/login_screen.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';
import 'package:quotes_app/modules/sign_up/bloc/sign_up_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => QuoteDataBloc()
              ..add(const FetchQuoteDataEvent())
              ..add(const FetchAdminDetailEvent())),
        BlocProvider(create: (context) => SignUpBloc()),
        BlocProvider(
          create: (context) => LoginBloc(),
        )
      ],
      child: const MaterialApp(
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
