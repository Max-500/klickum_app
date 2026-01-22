import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/presentation/providers/raffles_provider.dart';

class TicketContainer extends ConsumerWidget {
  final String myKey;
  final bool isMyTicket;
  final bool exists;

  const TicketContainer({super.key, required this.myKey, required this.isMyTicket, required this.exists});

  @override
  Widget build(BuildContext context, ref) {
    final labelLargeStyle = Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    return GestureDetector(
      onTap: () => ref.read(raffleTicketsProvider.notifier).toggleSinglePossibleTicket(myKey),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isMyTicket ? AppStyle.primaryColor : exists ? Colors.transparent : Colors.white.withAlpha(20),
          border: Border.all(color: isMyTicket ? AppStyle.primaryColor : Colors.white.withAlpha(15)),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Text(myKey, style: labelLargeStyle)
      )
    );
  }
}