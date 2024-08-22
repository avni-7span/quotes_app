import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';
import 'package:quotes_app/core/validators/email_validator.dart';
import 'package:quotes_app/core/validators/password_validator.dart';
import 'package:quotes_app/modules/sign-up/bloc/sign_up_bloc.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget implements AutoRouteWrapper {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: this,
    );
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isChecked = false;
  bool isPassVisible = true;
  bool isConfirmPassVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[300],
      body: BlocListener<SignUpBloc, SignUpState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) async {
            if (state.status == SignUpStateStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
              return;
            }
            if (state.status == SignUpStateStatus.success) {
              await context.replaceRoute(const QuoteRoute());
            }
          },
          child: BlocBuilder<SignUpBloc, SignUpState>(
            builder: (context, state) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/quote_pic.png', height: 150),
                            Text(
                              'Welcome',
                              style: TextStyle(
                                  fontSize: 40, color: Colors.grey[700]),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => context.read<SignUpBloc>().add(
                                EmailChangeEvent(value),
                              ),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: 'Enter Email',
                              errorText: state.email.displayError ==
                                      EmailValidationError.empty
                                  ? 'Email is required'
                                  : state.email.displayError ==
                                          EmailValidationError.invalid
                                      ? 'Invalid Email'
                                      : null),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          obscureText: isPassVisible,
                          onChanged: (value) => context
                              .read<SignUpBloc>()
                              .add(PasswordChangeEvent(value)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Enter Password',
                            errorMaxLines: 3,
                            errorText: state.password.displayError ==
                                    PasswordValidationError.empty
                                ? 'Password is required'
                                : state.password.displayError ==
                                        PasswordValidationError.invalid
                                    ? 'Password must be at least 8 characters long and contain at least one uppercase, one lowercase letter, one number, and one special character.'
                                    : null,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPassVisible = !isPassVisible;
                                });
                              },
                              icon: isPassVisible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          obscureText: isConfirmPassVisible,
                          onChanged: (value) => context
                              .read<SignUpBloc>()
                              .add(ConfirmPasswordChangeEvent(value)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Confirm Password',
                            errorText: state.confirmPassword.displayError ==
                                    PasswordValidationError.empty
                                ? 'Confirming Password is required'
                                : state.confirmPassword.displayError ==
                                        PasswordValidationError.invalid
                                    ? 'Password do not match'
                                    : null,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isConfirmPassVisible = !isConfirmPassVisible;
                                });
                              },
                              icon: isConfirmPassVisible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        const Text(
                            'Sign up as admin and get access to the feature of sharing your creative quotes with the world'),
                        CheckboxListTile(
                          secondary: const Icon(
                            Icons.admin_panel_settings_outlined,
                            size: 40,
                          ),
                          value: _isChecked,
                          selected: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                          title: const Text('Sign up as Admin?'),
                        ),
                        const SizedBox(height: 50),
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
                              context.read<SignUpBloc>().add(
                                    AdminCheckEvent(_isChecked),
                                  );
                              context.read<SignUpBloc>().add(
                                    const SigneUpButtonPressed(),
                                  );
                            },
                            child: state.status == SignUpStateStatus.loading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Sign Up',
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
                              await context.replaceRoute(const LoginRoute());
                            },
                            child: const Text(
                              'Already have an account ? Login',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
