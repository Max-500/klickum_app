import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/domain/entities/raffle.dart';
import 'package:klicum/presentation/providers/raffles_provider.dart';

class RaffleCard extends ConsumerWidget {
  final Raffle raffle;

  const RaffleCard({super.key, required this.raffle});

  @override
  Widget build(BuildContext context, ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis);
    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);
    final miniTitle = Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? TextStyle(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);

    final bodyLargeStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis);

    return GestureDetector(
      onTap: () {
        ref.read(raffleTicketIDProvider.notifier).setRaffleID(raffle.id);
        context.push('/raffle', extra: raffle);
      },
      child: Container(
        height: screenHeight * 0.15,
        width: screenWidth * 0.5,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppStyle.primaryColor.withValues(alpha: 0),
              AppStyle.primaryColor.withValues(alpha: 0.1),
              AppStyle.primaryColor.withValues(alpha: 0.1)
            ],
            stops: const [0.0, 0.5, 1.0]
          ),
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.15)),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    '${raffle.amount} Números',
                    style: subtitleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
      
                const SizedBox(width: 12), // separación mínima
      
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenWidth * 0.22), // ajusta
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${raffle.price}€',
                        style: titleStyle,
                        maxLines: 1,
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        '/ Nro',
                        style: miniTitle,
                        maxLines: 1,
                        textAlign: TextAlign.right,
                      )
                    ]
                  )
                )
              ]
            ),
            const Spacer(),
            Text('Premio', style: miniTitle),
            Text(raffle.reward, style: bodyLargeStyle)
          ]
        )
      ),
    );
  }
}