import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmer extends StatelessWidget {
  final Widget child;

  const MyShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: AppStyle.baseColor, 
    highlightColor: AppStyle.highlightColor,
    child: child
  );
}