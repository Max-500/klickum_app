import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/presentation/providers/error_providers.dart';
import 'package:klicum/presentation/providers/products_provider.dart';
import 'package:klicum/presentation/providers/raffles_provider.dart';
import 'package:klicum/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final scrollControllerRafles = ScrollController();
  final scrollControllerProducts = ScrollController();

  late final ProviderSubscription _errSub;

  @override
  void initState() {
    super.initState();

    _errSub = ref.listenManual<Object?>(homeErrorProvider, (errorPrev, error) {
      if (!mounted) return;

      if (error == null || error is SessionExpiredException) return;

      final colors = Theme.of(context).colorScheme;
      
      ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
        Helper.getSnackbar(
          color: Helper.isNetworkError(error) ? colors.tertiary : colors.error,
          isWarning: Helper.isNetworkError(error),
          text: Helper.isNetworkError(error) ? 'Sin conexion a internet' : Helper.normalizeError(error),
          duration: Helper.isNetworkError(error) ? const Duration(days: 1) : const Duration(seconds: 5)
        )
      );
      ref.read(homeErrorProvider.notifier).clear();
    });

    scrollControllerRafles.addListener(() {
      if (!mounted) return;

      final max = scrollControllerRafles.position.maxScrollExtent;
      final offset = scrollControllerRafles.offset;

      if (offset >= max - 300) ref.read(raffleProvider.notifier).loadMoreRaffles();
    });

    scrollControllerProducts.addListener(() {
      if (!mounted) return;
      if (ref.read<Object?>(homeErrorProvider.notifier) != null) return;

      final max = scrollControllerProducts.position.maxScrollExtent;
      final offset = scrollControllerProducts.offset;

      if (offset >= max - 300) ref.read(productProvider.notifier).loadMoreProducts();
    });
  }

  @override
  void dispose() {
    _errSub.close();
    scrollControllerProducts.dispose();
    scrollControllerRafles.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final displaySmallStyle = Theme.of(context).textTheme.displaySmall ?? const TextStyle();

    final titleStyle = Theme.of(context).textTheme.titleLarge ?? const TextStyle();

    final asyncRaffles = ref.watch(raffleProvider);
    final asyncProducts = ref.watch(productProvider);

    return RefreshIndicator(
      onRefresh: () async {
        try {
          ref.read(homeErrorProvider.notifier).clear();
          ref.invalidate(raffleProvider);
          ref.invalidate(productProvider);
          await ref.read(raffleProvider.future);
          if (mounted) await ref.read(productProvider.future);
        } catch (e) {
          if (mounted) ref.read(homeErrorProvider.notifier).setError(e);
        }
      },
      child: CustomScrollView(
        controller: scrollControllerProducts,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              children: [
                Text('Hola ', style: displaySmallStyle.copyWith(color: Colors.white)),
                Text('Leonardo', style: displaySmallStyle.copyWith(color: AppStyle.primaryColor))
              ]
            )
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 20)),

          SliverToBoxAdapter(
            child: Text('Rifas', style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200))
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 10)),

          SliverToBoxAdapter(
            child: SizedBox(
              height: (screenHeight * 0.125) + 32,
              child: asyncRaffles.when(
                data: (data) => data.isEmpty ? SliverFillRemaining(hasScrollBody: false, child: NoData(msg: 'No hay rifas disponibles')) : ListView.separated(
                  controller: scrollControllerRafles,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  separatorBuilder: (context, index) => SizedBox(width: screenWidth * 0.05),
                  itemBuilder: (context, index) => RaffleCard(raffle: data[index])
                ), 
                error: (error, stackTrace) => NoData(height: screenHeight * 0.05, msg: Helper.normalizeError(error)), 
                loading: () => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, _) => SizedBox(width: screenWidth * 0.05),
                  itemBuilder: (_, _) => RaffleCardSkeleton()
                )
              )
            )
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 20)),

          SliverToBoxAdapter(
            child: Text('Productos', style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200))
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 10)),

          asyncProducts.when(
            data: (data) => data.isEmpty ? SliverFillRemaining(hasScrollBody: false, child: NoData(msg: 'No hay productos disponibles')) : SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childCount: data.length,
              itemBuilder: (context, index) => ProductCard(product: data[index])
            ),
            error: (error, stackTrace) => SliverFillRemaining(hasScrollBody: false, child: NoData(msg: Helper.normalizeError(error))),
            loading: () => SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childCount: 6,
              itemBuilder: (context, index) => ProductCardSkeleton(height: index.isEven ? screenHeight * 0.4 : screenHeight * 0.4 + 20)
            )
          ),

          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom))
        ]
      )
    );
  }
}