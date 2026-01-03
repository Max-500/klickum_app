import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/domain/entities/raffle.dart';
import 'package:klicum/domain/entities/ticket.dart';
import 'package:klicum/presentation/providers/raffles_provider.dart';
import '../widgets/widgets.dart';

class RaffeScreen extends ConsumerStatefulWidget {
  final Raffle raffle;

  const RaffeScreen({super.key, required this.raffle});

  @override
  ConsumerState<RaffeScreen> createState() => _RaffleViewState();
}

class _RaffleViewState extends ConsumerState<RaffeScreen> {
  bool isLoading = false;

  SnackBar getSnackbar(Object error, Color color) => Helper.getSnackbar(
    color: color,
    isWarning: Helper.isNetworkError(error),
    text: Helper.isNetworkError(error) ? 'Sin conexion a internet' : Helper.normalizeError(error),
    duration: Helper.isNetworkError(error) ? const Duration(days: 1) : const Duration(seconds: 3),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final displayMediumStyle = Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final displaySmallStyle = Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final labelLargeStyle = Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w200,
      overflow: TextOverflow.ellipsis,
    ) ?? const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w200,
      overflow: TextOverflow.ellipsis,
    );

    final miniTitleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      color: Colors.white.withValues(alpha: 0.5),
      fontWeight: FontWeight.w200,
      overflow: TextOverflow.ellipsis,
    ) ?? TextStyle(
      color: Colors.white.withValues(alpha: 0.5),
      fontWeight: FontWeight.w200,
      overflow: TextOverflow.ellipsis,
    );

    final bodyLargeStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis);

    final colors = Theme.of(context).colorScheme;

    final asyncTickets = ref.watch(raffleTicketsProvider);

    ref.listen(raffleTicketsProvider, (previous, next) => next.whenOrNull(
      error: (error, stackTrace) {
        if (!mounted) return;
        if (error is SessionExpiredException) {
          Helper.handleTokenExpired();
          return;
        }

        ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(getSnackbar(error, Helper.isNetworkError(error) ? colors.tertiary : colors.error));
      }
    ));

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const FancyBackground(),

          Positioned(
            top: screenHeight * 0.05,
            child: SizedBox(
              width: screenWidth,
              child: const Center(child: MyTitle()),
            ),
          ),

          Positioned.fill(
            top: screenHeight * 0.12,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: RefreshIndicator(
              onRefresh: () async {
                try {
                  ref.invalidate(raffleTicketsProvider);
                  await ref.read(raffleTicketsProvider.future);
                // ignore: empty_catches
                } catch (e) {
                }
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Elegir Número', style: displaySmallStyle),
                        const SizedBox(height: 20),
                        Text('Premio', style: miniTitleStyle),
                        Row(
                          children: [
                            Text(widget.raffle.reward, style: bodyLargeStyle),
                            const Spacer(),
                            Text('${widget.raffle.amount} Números',
                                style: subtitleStyle),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
              
                  asyncTickets.when(
                    data: (data) {
                      final selected = data.values.cast<Ticket?>().firstWhere(
                        (t) => t!.isMyTicket && t.id == 'no-id',
                        orElse: () => null,
                      );
                      final hasSelection = selected != null;
              
                      return SliverMainAxisGroup(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.zero,
                            sliver: SliverGrid(
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: screenWidth * 0.1,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final key = (index + 1).toString();
                                  final ticket = data[key];
              
                                  final exists = ticket != null;
                                  final isMyTicket = ticket?.isMyTicket ?? false;
              
                                  return GestureDetector(
                                    onTap: () => ref.read(raffleTicketsProvider.notifier).toggleSinglePossibleTicket(key),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isMyTicket
                                            ? AppStyle.primaryColor
                                            : exists
                                                ? Colors.transparent
                                                : Colors.white.withAlpha(20),
                                        border: Border.all(
                                          color: isMyTicket ? AppStyle.primaryColor : Colors.white.withAlpha(15)
                                        ),
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Text(key, style: labelLargeStyle)
                                    )
                                  );
                                },
                                childCount: widget.raffle.amount
                              )
                            )
                          ),
              
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text('${widget.raffle.price}€', style: displayMediumStyle),
                                    const SizedBox(width: 6),
                                    Text('/Nro', style: miniTitleStyle)
                                  ]
                                ),
                                const SizedBox(height: 20),
              
                                hasSelection
                                  ? SizedBox(
                                      width: double.infinity,
                                      height: screenHeight * 0.05,
                                      child: Button(
                                        text: 'Comprar Número',
                                        style: subtitleStyle.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        callback: () async {
                                          try {
                                            if (isLoading) return;
                                            isLoading = true;
                                            await ref.read(raffleTicketsProvider.notifier).purchaseTicket(raffleId: widget.raffle.id, code: selected.code);
                                            if (!mounted) return;
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(Helper.getSnackbar(
                                              color: colors.primary,
                                              isWarning: false,
                                              text: 'Número adquirido correctamente',
                                              duration: const Duration(seconds: 5),
                                              isSuccess: true
                                            ));
                                          } catch(error) {
                                            if (!mounted) return;
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(getSnackbar(error, Helper.isNetworkError(error) ? colors.tertiary : colors.error));
                                          } finally {
                                            isLoading = false;
                                          }
                                        },
                                      ),
                                    )
                                  : const SizedBox.shrink(),
              
                                SizedBox(height: MediaQuery.of(context).padding.bottom)
                              ]
                            )
                          )
                        ]
                      );
                    },
                    error: (e, st) => SliverToBoxAdapter(child: SizedBox.shrink()),
                    loading: () => const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator())
                    )
                  )
                ]
              ),
            )
          )
        ]
      )
    );
  }
}