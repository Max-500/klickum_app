import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:shimmer/shimmer.dart';

class ImageCardSkeleton extends StatelessWidget {
  const ImageCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: AppStyle.baseColor,
    highlightColor: AppStyle.highlightColor,
    child: Container(
      decoration: BoxDecoration(
        color: AppStyle.backgroundColorSkeleton,
        border: Border.all(color: Colors.white.withAlpha(15)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15)
        ),
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