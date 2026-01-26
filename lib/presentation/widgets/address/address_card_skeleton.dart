import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/presentation/widgets/shared/my_shimmer.dart';

class AddressCardSkeleton extends StatelessWidget {
  const AddressCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => MyShimmer(
    child: Container(
      height: MediaQuery.of(context).size.height * 0.15,
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