import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/domain/entities/my_raffle.dart';

class MyRaffleCard extends StatelessWidget {
  final MyRaffle myRaffle;

  const MyRaffleCard({super.key, required this.myRaffle});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis);
    final miniTitle = Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? TextStyle(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);

    final bodyLargeStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis);

    return IntrinsicWidth(
      child: Container(
        constraints: BoxConstraints(minHeight: screenHeight * 0.15, minWidth: screenWidth * 0.4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppStyle.primaryColor.withValues(alpha: 0),
              AppStyle.primaryColor.withValues(alpha: 0.1),
              AppStyle.primaryColor.withValues(alpha: 0.1),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.15)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Premio', style: miniTitle),
                    Text(myRaffle.raffle.reward, style: bodyLargeStyle)
                  ],
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: myRaffle.isActive ?AppStyle.primaryColor : const Color(0xFFB3261E),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Text(
                    myRaffle.isActive ? 'Activo' : 'Desactivado', 
                    style: miniTitle.copyWith(color: const Color.fromRGBO(8, 13, 0, 1), fontWeight: FontWeight.normal)
                  )
                )
              ]
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Número', style: miniTitle),
                Text((int.parse(myRaffle.code) + 1).toString(), style: subtitleStyle)
              ]
            )
          ]
        )
      )
    );
  }
}