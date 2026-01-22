import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/presentation/widgets/shared/my_shimmer.dart';

class RaffleCardSkeleton extends StatelessWidget {
  const RaffleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return MyShimmer(
      child: Container(
        height: screenHeight * 0.15,
        width: screenWidth * 0.5,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppStyle.backgroundColorSkeleton,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withAlpha(6), width: 1),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppStyle.gradients,
            stops: [0.0, 0.55, 1.0]
          )
        )
      )
    );
  }
}