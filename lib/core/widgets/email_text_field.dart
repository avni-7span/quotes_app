import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField(
      {super.key, required this.errorText, required this.onChangedFunction});

  final String? errorText;
  final Function(String) onChangedFunction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => onChangedFunction(value),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        labelText: 'Enter Email',
        errorText: errorText,
      ),
    );
  }
}
