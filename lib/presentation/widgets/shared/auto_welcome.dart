import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';

class AutoWelcome extends StatelessWidget {
  final Widget? widget;
  final String title;
  final String subtitle;

  const AutoWelcome({
    super.key, 
    this.widget, 
    this.title = 'Komunly', 
    required this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final titleStyle = Theme.of(context).textTheme.titleLarge ?? const TextStyle();
    final subtitleStyle = Theme.of(context).textTheme.titleMedium ?? const TextStyle();

    final baseSize = titleStyle.fontSize ?? screenHeight * 0.05;
    final textHeight = baseSize * (titleStyle.height ?? 1.2);

    return Container(
      alignment: Alignment.center,
      width: screenWidth * 0.9,
      constraints: BoxConstraints(minHeight: screenHeight * 0.1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Color.fromRGBO(8, 13, 0, 0.75)),
        color: Color.fromRGBO(8, 13, 0, 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Baseline(
                baseline: textHeight * 0.85,
                baselineType: TextBaseline.alphabetic,
                child: widget ?? Image.asset(
                  'assets/images/logo.png',
                  height: textHeight * 1.15,
                  fit: BoxFit.contain
                )
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: titleStyle.copyWith(
                  color: AppStyle.primaryColor,
                  fontWeight: FontWeight.bold
                )
              )
            ]
          ),

          Text(
            subtitle,
            style: subtitleStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w200
            )
          )
        ]
      )
    );
  }
}
