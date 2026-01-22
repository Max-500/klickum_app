import 'package:flutter/material.dart';

class SliverGridRaffleTicketBooklet extends StatelessWidget {
  final int? childCount;
  final Widget? child;
  final SliverChildBuilderDelegate? delegate;

  const SliverGridRaffleTicketBooklet({super.key, this.childCount, this.child, this.delegate});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SliverGrid(
      delegate: delegate ?? SliverChildBuilderDelegate(
        (context, index) => child,
        childCount: childCount
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: screenWidth * 0.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
    );
  }
}
