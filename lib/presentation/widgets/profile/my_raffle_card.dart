import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';

class MyRaffleCard extends StatelessWidget {
  const MyRaffleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis);
    final miniTitle = Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? TextStyle(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);

    final bodyLargeStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis);

    final data = ['15', '26', '38', '15', '26', '38','15', '26', '38'];

    return Container(
      constraints: BoxConstraints(minHeight: screenHeight * 0.15),
      width: screenWidth * 0.5,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppStyle.primaryColor.withValues(alpha: 0),
            AppStyle.primaryColor.withValues(alpha: 0.1),
            AppStyle.primaryColor.withValues(alpha: 0.1)
          ],
          stops: const [0.0, 0.5, 1.0]
        ),
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.15)),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Premio', style: miniTitle),
          Text('Galaxy S24', style: bodyLargeStyle),
          const Spacer(),
          Text('Mis Números', style: miniTitle),
          Text(data.join('-'), style: subtitleStyle,)
        ]
      )
    );

  }
}