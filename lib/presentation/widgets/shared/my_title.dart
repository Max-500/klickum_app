import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';

class MyTitle extends StatelessWidget {
  const MyTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge ?? const TextStyle();

    final screenHeight = MediaQuery.of(context).size.height;

    final baseSize = titleStyle.fontSize ?? screenHeight * 0.05;
    final textHeight = baseSize * (titleStyle.height ?? 1.2);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Baseline(
          baseline: textHeight * 0.85,
          baselineType: TextBaseline.alphabetic,
          child: Image.asset(
            'assets/images/logo.png',
            height: textHeight * 1.15,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          'Klickum',
          style: titleStyle.copyWith(
            color: AppStyle.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}