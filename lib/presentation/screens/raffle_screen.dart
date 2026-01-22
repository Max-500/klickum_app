// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/domain/entities/raffle.dart';
import 'package:klicum/domain/entities/ticket.dart';
import 'package:klicum/presentation/providers/error_providers.dart';
import 'package:klicum/presentation/providers/raffles_provider.dart';
import '../widgets/widgets.dart';

class RaffeScreen extends ConsumerStatefulWidget {
  final Raffle raffle;

  const RaffeScreen({super.key, required this.raffle});

  @override
  ConsumerState<RaffeScreen> createState() => _RaffleViewState();
}

class _RaffleViewState extends ConsumerState<RaffeScreen> {
  late final ProviderSubscription _errSub;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _errSub = ref.listenManual<Object?>(raffleTicketsErrorProvider, (errorPrev, error) {
      if (!mounted) return;

      if (error == null || error is SessionExpiredException) return;

      final colors = Theme.of(context).colorScheme;

      String msg = '';

      if (errorPrev != null) msg = Helper.normalizeError(errorPrev);
      msg = '$msg\n${Helper.normalizeError(error)}';
      
      ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
        Helper.getSnackbar(
          color: Helper.isNetworkError(error) ? colors.tertiary : colors.error,
          isWarning: Helper.isNetworkError(error),
          text: Helper.isNetworkError(error) ? 'Sin conexion a internet' : Helper.normalizeError(error),
          duration: const Duration(seconds: 5)
        )
      );
      ref.read(homeErrorProvider.notifier).clear();
    });
  }

  @override
  void dispose() {
    _errSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final displayMediumStyle = Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final displaySmallStyle = Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

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

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const FancyBackground(),
          Positioned(
            top: screenHeight * 0.05,
            child: SizedBox(
              width: screenWidth,
              child: const Center(child: MyTitle())
            )
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
                } catch (e) {
                  if (mounted) ref.read(raffleTicketsErrorProvider.notifier).setError(e);
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
                            sliver: SliverGridRaffleTicketBooklet(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final myKey = (index + 1).toString();
                                  final ticket = data[myKey];
              
                                  final exists = ticket != null;
                                  final isMyTicket = ticket?.isMyTicket ?? false;
              
                                  return TicketContainer(myKey: myKey, isMyTicket: isMyTicket, exists: exists);
                                },
                                childCount: widget.raffle.amount
                              ),
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
                                        style: subtitleStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                                        callback: () async {
                                          try {
                                            if (isLoading) return;
                                            isLoading = true;
                                            await ref.read(raffleTicketsProvider.notifier).purchaseTicket(raffleId: widget.raffle.id, code: selected.code);
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                                              Helper.getSnackbar(
                                                color: colors.primary,
                                                isWarning: false,
                                                text: 'Número adquirido correctamente',
                                                duration: const Duration(seconds: 5),
                                                isSuccess: true
                                              )
                                            );
                                          } catch(error) {
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                                              Helper.getSnackbar(
                                                color: Helper.isNetworkError(error) ? colors.tertiary : colors.error,
                                                isWarning: Helper.isNetworkError(error),
                                                text: Helper.isNetworkError(error) ? 'Sin conexion a internet' : 'Error al comprar el ticket',
                                                duration: const Duration(seconds: 5)
                                              )
                                            );
                                          } finally {
                                            isLoading = false;
                                          }
                                        }
                                      )
                                    )
                                  : const SizedBox.shrink(),
              
                                SizedBox(height: MediaQuery.of(context).padding.bottom)
                              ]
                            )
                          )
                        ]
                      );
                    },
                    error: (e, st) => SliverToBoxAdapter(
                      child: SizedBox(
                        height: screenHeight * 0.4, 
                        child: NoData(msg: Helper.isNetworkError(e) ? 'Sin conexión a internet' : Helper.normalizeError(e))
                      )
                    ),
                    loading: () => SliverPadding(
                      padding: EdgeInsets.zero,
                      sliver: SliverGridRaffleTicketBooklet(childCount: widget.raffle.amount, child: RaffleTicketsSkeleton())
                    )
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}