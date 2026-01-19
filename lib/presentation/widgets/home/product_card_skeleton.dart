import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardSkeleton extends StatelessWidget {
  final double height;

  const ProductCardSkeleton({super.key, required this.height});

  @override
  Widget build(BuildContext context) {

    return Shimmer.fromColors(
      baseColor: AppStyle.baseColor,
      highlightColor: AppStyle.highlightColor,
      child: Container(
        height: height,
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