import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';
import '../widgets.dart';

class MyRaffleCardSkeleton extends StatelessWidget {
  const MyRaffleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return MyShimmer(
      child: Container(
        height: screenHeight * 0.15,
        width: screenWidth * 0.55,
        decoration: BoxDecoration(
          color: AppStyle.backgroundColorSkeleton,
          border: Border.all(color: Colors.white.withAlpha(15)),
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppStyle.gradients,
            stops: [0.0, 0.55, 1.0]
          )
        ),
        clipBehavior: Clip.hardEdge
      )
    );
  }
}