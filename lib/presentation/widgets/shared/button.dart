import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final TextStyle? style;

  const Button({super.key, required this.callback, required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback, 
      child: Text(text, style: style)
    );
  }
}