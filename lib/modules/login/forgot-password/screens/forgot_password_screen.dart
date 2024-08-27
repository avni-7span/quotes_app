import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/const_strings.dart';
import 'package:quotes_app/core/validators/email_validator.dart';
import 'package:quotes_app/core/widgets/custom_material_button.dart';
import 'package:quotes_app/core/widgets/email_text_field.dart';
import 'package:quotes_app/modules/login/forgot-password/bloc/forgot_password_bloc.dart';

@RoutePage()
class ForgotPasswordScreen extends StatefulWidget implements AutoRouteWrapper {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (context) => ForgotPasswordBloc(), child: this);
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Recover Password'),
        backgroundColor: Colors.blue[200],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/wrong-password.png',
                      height: 120,
                      color: Colors.grey[800],
                    ),
                    const SizedBox(height: 40),
                    EmailTextField(
                      errorText:
                          state.email.displayError == EmailValidationError.empty
                              ? 'Email is required'
                              : state.email.displayError ==
                                      EmailValidationError.invalid
                                  ? 'Invalid Email'
                                  : null,
                      onChangedFunction: (value) {
                        context.read<ForgotPasswordBloc>().add(
                              EmailFieldChangeEvent(value),
                            );
                      },
                    ),
                    const SizedBox(height: 50),
                    CustomMaterialButton(
                      onPressed: () => context
                          .read<ForgotPasswordBloc>()
                          .add(const SendEmailForPasswordEvent()),
                      buttonLabelWidget:
                          state.status == ForgotPasswordStateStatus.loading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Reset Password',
                                  style: TextStyle(fontSize: 20),
                                ),
                    ),
                    const SizedBox(height: 40),
                    if (state.status == ForgotPasswordStateStatus.success)
                      Text(
                        textAlign: TextAlign.center,
                        ConstantStrings.passwordSend,
                        style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
