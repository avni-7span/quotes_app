import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.isVisible = true,
    required this.onChanged,
    required this.errorText,
  });

  final bool isVisible;
  final Function(String) onChanged;
  final String? errorText;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool shouldShowPassword = false;

  @override
  void initState() {
    super.initState();
    shouldShowPassword = widget.isVisible;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: shouldShowPassword,
      onChanged: (value) => widget.onChanged(value),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        labelText: 'Enter Password',
        errorText: widget.errorText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              shouldShowPassword = !shouldShowPassword;
            });
          },
          icon: shouldShowPassword
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
        ),
      ),
    );
  }
}
