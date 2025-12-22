import 'dart:math';
import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';

import '../widgets/widgets.dart';

class RaffleView extends StatelessWidget {
  const RaffleView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final displayMediumStyle = Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
    final displaySmallStyle = Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
    
    final labelLargeStyle = Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);
    final miniTitleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? TextStyle(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);

    final bodyLargeStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Elegir Número', style: displaySmallStyle),
          const SizedBox(height: 20),
      
          Text('Premio', style: miniTitleStyle),
          Row(
            children: [
              Text('Galaxy S24', style: bodyLargeStyle),
              const Spacer(),
              Text('90 Números', style: subtitleStyle)
            ]
          ),
      
          const SizedBox(height: 15),
      
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: screenWidth * 0.075,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1
            ),
            itemCount: 90,
            itemBuilder: (context, index) {
              final number = Random().nextInt(3);
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: number == 0
                      ? Colors.white.withValues(alpha: 0.1)
                      : number == 1
                          ? Colors.transparent
                          : AppStyle.primaryColor,
                  border: Border.all(
                    color: (number == 0 || number == 1) ? Colors.white.withValues(alpha: 0.15) : AppStyle.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text(number.toString(), style: labelLargeStyle)
              );
            }
          ),
      
          const SizedBox(height: 20),
      
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('8.5€', style: displayMediumStyle),
              const SizedBox(width: 6),
              Text('/Nro', style: miniTitleStyle)
            ]
          ),
      
          const SizedBox(height: 20),
      
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.05,
            child: Button(
              text: 'Comprar 3 Números',
              style: subtitleStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
              callback: () {
                
              }
            )
          )
        ]
      ),
    );
  }
}