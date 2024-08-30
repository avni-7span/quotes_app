import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField(
      {super.key, required this.errorText, required this.onChanged});

  final String? errorText;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => onChanged(value),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        labelText: 'Enter Email',
        errorText: errorText,
      ),
    );
  }
}
