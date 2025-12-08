import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ActionText extends StatelessWidget {
  final String prefix;
  final String action;
  final VoidCallback onActionTap;

  const ActionText({super.key, required this.prefix, required this.action, required this.onActionTap});

  @override
  Widget build(BuildContext context) {
    final labelLargeStyle = Theme.of(context).textTheme.labelLarge ?? const TextStyle();

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$prefix ',
            style: labelLargeStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200)
          ),
          TextSpan(
            text: action,
            style: labelLargeStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            recognizer: TapGestureRecognizer()..onTap = onActionTap
          )
        ]
      )
    );
  }
}