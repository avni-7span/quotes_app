import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/login/bloc/login_bloc.dart';
import 'package:quotes_app/modules/quotes/screens/quote_screen.dart';
import 'package:quotes_app/modules/sign_up/screens/sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStateStatus.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const QuoteScreen(),
            ),
          );
          return;
        }
        if (state.status == LoginStateStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Be what you want to be',
                    style: TextStyle(color: Colors.purple, fontSize: 30),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    onChanged: (value) => context
                        .read<LoginBloc>()
                        .add(EmailFieldChangeEvent(value)),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Enter Email',
                        errorText: state.email.displayError != null
                            ? 'Invalid Email'
                            : null),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) => context
                        .read<LoginBloc>()
                        .add(PasswordFieldChangeEvent(value)),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Enter Password',
                        errorText: state.password.displayError != null
                            ? 'Invalid Password'
                            : null),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade100,
                        shape: const RoundedRectangleBorder(),
                      ),
                      onPressed: () {
                        context
                            .read<LoginBloc>()
                            .add(const LoginButtonPressedEvent());
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade100,
                        shape: const RoundedRectangleBorder(),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Don\'t have an account ? Signup',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
