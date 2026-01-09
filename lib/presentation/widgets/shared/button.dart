import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? callback;
  final String text;
  final TextStyle? style;
  final Color? backgroundColor;
  final Color? borderColor;

  const Button({super.key, required this.callback, required this.text, this.style, this.backgroundColor,this.borderColor});

  @override
  Widget build(BuildContext context) {
    final labelLargeStyle = Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.black, fontWeight: FontWeight.w600);


    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: backgroundColor == null ? null : WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return backgroundColor!.withValues(alpha: 0.8);
          return backgroundColor;
        }),
        shape: borderColor == null ? null : WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: borderColor!
            )
          )
        )
      ),
      onPressed: callback, 
      child: Text(text, style: style ?? labelLargeStyle)
    );
  }
}