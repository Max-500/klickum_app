import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/presentation/widgets/widgets.dart';

class RaffleTicketsSkeleton extends StatelessWidget {
  const RaffleTicketsSkeleton({super.key});

  @override
  Widget build(BuildContext context) => MyShimmer(
    child: Container(
      decoration: BoxDecoration(
        color: AppStyle.backgroundColorSkeleton,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(6), width: 1)
      )
    )
  );
}
