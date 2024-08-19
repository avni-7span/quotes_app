import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/routes/router.dart';
import 'package:quotes_app/firebase_options.dart';
import 'package:quotes_app/modules/login/bloc/login_bloc.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';
import 'package:quotes_app/modules/sign_up/bloc/sign_up_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  final _router = AppRouter();

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
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router.config(),
      ),
    );
  }
}
