import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/routes/router.gr.dart';
import 'package:quotes_app/modules/login/bloc/login_bloc.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStateStatus.success) {
          context.router.replace(const QuoteRoute());
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
            backgroundColor: Colors.grey[300],
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/quote.png',
                          height: 80,
                        ),
                        SizedBox(height: 20),
                        const Text(
                          'Welcome Again!',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
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
                          width: double.infinity,
                          child: MaterialButton(
                            color: Colors.blue.shade200,
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
                          width: double.infinity,
                          child: MaterialButton(
                            color: Colors.blue.shade200,
                            onPressed: () {
                              context.router.push(const SignUpRoute());
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
