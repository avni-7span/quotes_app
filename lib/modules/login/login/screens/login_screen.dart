import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';
import 'package:quotes_app/core/validators/email_validator.dart';
import 'package:quotes_app/core/widgets/custom_material_button.dart';
import 'package:quotes_app/core/widgets/email_text_field.dart';
import 'package:quotes_app/core/widgets/password_text_field.dart';
import 'package:quotes_app/modules/login/login/bloc/login_bloc.dart';
import 'package:quotes_app/modules/login/login/widgets/verification_alert_widget.dart';

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
  bool isVisible = true;
  static const TextStyle textStyle = TextStyle(fontSize: 20);

  Future _showAlertDialogue({required BuildContext loginScreenContext}) async {
    showDialog(
      context: loginScreenContext,
      useRootNavigator: true,
      builder: (context) {
        return BlocProvider.value(
            value: BlocProvider.of<LoginBloc>(loginScreenContext),
            child: VerificationAlertWidget(
              onClosedTap: () {
                Navigator.pop(loginScreenContext);
              },
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state.status == LoginStateStatus.success) {
          await context.replaceRoute(const QuoteRoute());
        } else if (state.status == LoginStateStatus.notVerified) {
          _showAlertDialogue(loginScreenContext: context);
        } else if (state.status == LoginStateStatus.emailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'We have send you verification email; Please chech inbox'),
            ),
          );
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
                        EmailTextField(
                          errorText: state.email.displayError ==
                                  EmailValidationError.empty
                              ? 'Email is required'
                              : state.email.displayError ==
                                      EmailValidationError.invalid
                                  ? 'Invalid Email'
                                  : null,
                          onChangedFunction: (value) =>
                              context.read<LoginBloc>().add(
                                    EmailFieldChangeEvent(value),
                                  ),
                        ),
                        const SizedBox(height: 20),
                        PasswordTextField(
                          isVisible: isVisible,
                          onChanged: (value) => context
                              .read<LoginBloc>()
                              .add(PasswordFieldChangeEvent(value)),
                          errorText: state.password.displayError != null
                              ? 'Password is required'
                              : null,
                        ),
                        const SizedBox(height: 30),
                        CustomMaterialButton(
                          onPressed: () {
                            context
                                .read<LoginBloc>()
                                .add(const LoginButtonPressedEvent());
                          },
                          buttonLabelWidget:
                              state.status == LoginStateStatus.loading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Login',
                                      style: textStyle,
                                    ),
                        ),
                        const SizedBox(height: 27),
                        CustomMaterialButton(
                          onPressed: () async {
                            await context.pushRoute(const SignUpRoute());
                          },
                          buttonLabelWidget: const Text(
                            'Create New Account',
                            style: textStyle,
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () =>
                              context.router.push(const ForgotPasswordRoute()),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              color: Colors.grey[800],
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
