import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/sign_up/bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Be what you want to be',
                  style: TextStyle(color: Colors.purple, fontSize: 30),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  onChanged: (value) =>
                      context.read<SignUpBloc>().add(EmailChangeEvent(value)),
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
                      .read<SignUpBloc>()
                      .add(PasswordChangeEvent(value)),
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Enter Password',
                      errorText: state.email.displayError != null
                          ? 'Invalid Password'
                          : null),
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  secondary: const Icon(Icons.admin_panel_settings_outlined),
                  value: _isChecked,
                  selected: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                  title: const Text('Sign up as Admin?'),
                  subtitle: const Text(
                      'Get chance to share your creative quotes with the world'),
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
                          .read<SignUpBloc>()
                          .add(AdminCheckEvent(_isChecked));
                      context.read<SignUpBloc>().add(const SignUpEvent());
                    },
                    child: const Text(
                      'Sign Up',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
