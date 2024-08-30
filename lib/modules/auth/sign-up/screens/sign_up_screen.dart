import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/const_strings.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';
import 'package:quotes_app/core/validators/confirm_password_validator.dart';
import 'package:quotes_app/core/validators/email_validator.dart';
import 'package:quotes_app/core/validators/password_validator.dart';
import 'package:quotes_app/core/widgets/custom_material_button.dart';
import 'package:quotes_app/core/widgets/email_text_field.dart';
import 'package:quotes_app/core/widgets/password_text_field.dart';
import 'package:quotes_app/modules/auth/sign-up/app_checklist_tile.dart';
import 'package:quotes_app/modules/auth/sign-up/bloc/sign_up_bloc.dart';

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
  static const TextStyle textStyle = TextStyle(fontSize: 20);

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
          }
          if (state.status == SignUpStateStatus.success) {
            await context.replaceRoute(const VerificationWaitingRoute());
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
                          Image.asset('assets/quote_pic.png', height: 100),
                          Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.grey.shade700,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      EmailTextField(
                        errorText: state.email.displayError ==
                                EmailValidationError.empty
                            ? 'Email is required'
                            : state.email.displayError ==
                                    EmailValidationError.invalid
                                ? 'Invalid Email'
                                : null,
                        onChanged: (value) => context.read<SignUpBloc>().add(
                              EmailChangeEvent(value),
                            ),
                      ),
                      const SizedBox(height: 20),
                      PasswordTextField(
                        label: 'Enter Password',
                        onChanged: (value) => context.read<SignUpBloc>().add(
                              PasswordChangeEvent(value),
                            ),
                        errorText: state.password.displayError ==
                                PasswordValidationError.passEmpty
                            ? 'Password is required'
                            : state.password.displayError ==
                                    PasswordValidationError.invalid
                                ? ConstantStrings.passwordErrorText
                                : null,
                      ),
                      const SizedBox(height: 20),
                      PasswordTextField(
                        label: 'Confirm Password',
                        onChanged: (value) => context
                            .read<SignUpBloc>()
                            .add(ConfirmPasswordChangeEvent(value)),
                        errorText: state.confirmPassword.displayError ==
                                ConfirmPasswordValidationError.passEmpty
                            ? 'Confirming Password is required'
                            : state.confirmPassword.displayError ==
                                    ConfirmPasswordValidationError.invalid
                                ? 'Confirm password do not match with password'
                                : null,
                      ),
                      const SizedBox(height: 60),
                      const Text(ConstantStrings.adminFeatureInfo),
                      AppCheckListTile(
                        title: 'Sign up as Admin?',
                        onChanged: (value) {
                          context.read<SignUpBloc>().add(
                                ToggleAdminEvent(value),
                              );
                        },
                      ),
                      const SizedBox(height: 40),
                      CustomMaterialButton(
                        onPressed: () {
                          context.read<SignUpBloc>().add(
                                const SignUpButtonPressed(),
                              );
                        },
                        buttonLabelWidget:
                            state.status == SignUpStateStatus.loading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Sign Up',
                                    style: textStyle,
                                  ),
                      ),
                      const SizedBox(height: 20),
                      CustomMaterialButton(
                        onPressed: () async {
                          await context.replaceRoute(
                            const LoginRoute(),
                          );
                        },
                        buttonLabelWidget: const Text(
                          'Login Into Existing Account ',
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
