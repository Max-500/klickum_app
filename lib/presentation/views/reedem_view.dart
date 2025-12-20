import 'package:flutter/material.dart';
import 'package:klicum/presentation/widgets/widgets.dart';

class ReedemView extends StatelessWidget {
  const ReedemView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final displaySmallStyle = Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);

    final labelLargeStyle = Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.black, fontWeight: FontWeight.w600);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Canjear Código', style: displaySmallStyle),
        SizedBox(height: screenHeight * 0.05),
        Text('Introducir Código', style: subtitleStyle),
        const SizedBox(height: 5),
        InputField(autoValidateMode: false, labelText: ''),
        SizedBox(height: screenHeight * 0.1),
        SizedBox(
          width: double.infinity,
          height: screenHeight * 0.05,
          child: Button(callback: () {}, text: 'Canjear', style: labelLargeStyle)
        )
      ]
    );
  }
}