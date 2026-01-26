import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/presentation/widgets/shared/my_shimmer.dart';

class MyOrderCardSkeleton extends StatelessWidget {
  const MyOrderCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        MyShimmer(
          child: Container(
            height: screenHeight * 0.2,
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
        ),

        const SizedBox(height: 20)
      ],
    );
  }
}