import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final double? height;

  const NoData({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge ?? const TextStyle();

    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: Colors.white.withAlpha(85),
            size: height ?? screenHeight * 0.1
          ),
          Text(
            'No hay productos',
            style: titleStyle.copyWith(
              color: Colors.white.withAlpha(85),
              fontWeight: FontWeight.w600
            )
          )
        ]
      )
    );
  }
}
