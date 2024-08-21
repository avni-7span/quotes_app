import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';
import 'package:quotes_app/modules/login/bloc/login_bloc.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';

@RoutePage()
class LoginScreen extends StatefulWidget implements AutoRouteWrapper {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: this,
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state.status == LoginStateStatus.success) {
          await context.replaceRoute(const QuoteRoute());
        } else if (state.status == LoginStateStatus.failure) {
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
                        const SizedBox(height: 20),
                        const Text(
                          'Welcome Again!',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => context
                              .read<LoginBloc>()
                              .add(EmailFieldChangeEvent(value)),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: 'Enter Email',
                              errorText: state.email.displayError != null
                                  ? 'Invalid Email'
                                  : null),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          obscureText: isVisible,
                          onChanged: (value) => context
                              .read<LoginBloc>()
                              .add(PasswordFieldChangeEvent(value)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Enter Password',
                            errorText: state.password.displayError != null
                                ? 'Invalid Password'
                                : null,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: isVisible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: MaterialButton(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.blue.shade200,
                            onPressed: () {
                              context
                                  .read<LoginBloc>()
                                  .add(const LoginButtonPressedEvent());
                            },
                            child: state.status == LoginStateStatus.loading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 20),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: MaterialButton(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.blue.shade200,
                            onPressed: () async {
                              await context.replaceRoute(const SignUpRoute());
                            },
                            child: const Text(
                              'Don\'t have an account ? Signup',
                              style: TextStyle(fontSize: 20),
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
