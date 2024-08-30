import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    super.key,
    required this.onPressed,
    required this.buttonLabelWidget,
  });

  final VoidCallback onPressed;

  // TODO
  final Widget buttonLabelWidget;

  // final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: MaterialButton(
        onPressed: onPressed,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.blue.shade200,
        child: buttonLabelWidget,
      ),
    );
  }
}
