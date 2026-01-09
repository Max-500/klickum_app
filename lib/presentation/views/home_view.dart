import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/presentation/providers/products_provider.dart';
import 'package:klicum/presentation/providers/raffles_provider.dart';
import 'package:klicum/presentation/widgets/shared/no_data.dart';
import 'package:klicum/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final scrollControllerRafles = ScrollController();
  final scrollControllerProducts = ScrollController();


  @override
  void initState() {
    super.initState();

    scrollControllerRafles.addListener(() {
      if (!mounted) return;

      final max = scrollControllerRafles.position.maxScrollExtent;
      final offset = scrollControllerRafles.offset;

      if (offset >= max - 300) ref.read(raffleProvider.notifier).loadMoreRaffles();
    });

    scrollControllerProducts.addListener(() {
      if (!mounted) return;

      final max = scrollControllerProducts.position.maxScrollExtent;
      final offset = scrollControllerProducts.offset;

      if (offset >= max - 300) ref.read(productProvider.notifier).loadMoreProducts();
    });
  }

  @override
  void dispose() {
    scrollControllerProducts.dispose();
    super.dispose();
  }

  SnackBar getSnackbar(Object error, Color color) => Helper.getSnackbar(
    color: color,
    isWarning: Helper.isNetworkError(error),
    text: Helper.isNetworkError(error) ? 'Sin conexion a internet' : Helper.normalizeError(error),
    duration: Helper.isNetworkError(error) ? const Duration(days: 1) : null,
  );
  

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final displaySmallStyle = Theme.of(context).textTheme.displaySmall ?? const TextStyle();

    final titleStyle = Theme.of(context).textTheme.titleLarge ?? const TextStyle();

    final colors = Theme.of(context).colorScheme;

    final asyncRaffles = ref.watch(raffleProvider);
    final asyncProducts = ref.watch(productProvider);

    ref.listen(raffleProvider, (previous, next) => next.whenOrNull(
      error: (error, stackTrace) {
        if (!mounted) return;
        if (error is SessionExpiredException) {
          Helper.handleTokenExpired();
          return;
        }

        ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(getSnackbar(error, Helper.isNetworkError(error) ? colors.tertiary : colors.error));
      }
    ));


    ref.listen(productProvider, (previous, next) => next.whenOrNull(
      error: (error, stackTrace) {
        if (!mounted) return;
        if (error is SessionExpiredException) {
          Helper.handleTokenExpired();
          return;
        }

        ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(getSnackbar(error, Helper.isNetworkError(error) ? colors.tertiary : colors.error));
      }
    ));

    ref.listen(loadMoreProductsErrorProvider, (prev, next) {
      if (!mounted) return;
      if (next == null || next is SessionExpiredException) return;
      ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(getSnackbar(next, Helper.isNetworkError(next) ? colors.tertiary : colors.error));
      ref.read(loadMoreProductsErrorProvider.notifier).clear();
    });

    return RefreshIndicator(
      onRefresh: () async {
        try {
          ref.read(loadMoreProductsErrorProvider.notifier).clear();
          ref.invalidate(raffleProvider);
          await ref.read(raffleProvider.future);
          ref.invalidate(productProvider);
          await ref.read(productProvider.future);
        // ignore: empty_catches
        } catch (e) {}
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
                data: (data) => ListView.separated(
                  controller: scrollControllerRafles,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  separatorBuilder: (context, index) => SizedBox(width: screenWidth * 0.05),
                  itemBuilder: (context, index) => RaffleCard(raffle: data[index])
                ), 
                error: (error, stackTrace) => NoData(height: screenHeight * 0.05,), 
                loading: () => const CircularProgressIndicator(),
              )
            )
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 20)),

          SliverToBoxAdapter(
            child: Text('Productos', style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200))
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 10)),

          asyncProducts.when(
            data: (data) => data.isEmpty ? SliverFillRemaining(hasScrollBody: false, child: NoData()) : SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childCount: data.length,
              itemBuilder: (context, index) => ProductCard(product: data[index])
            ),
            error: (error, stackTrace) => SliverFillRemaining(hasScrollBody: false, child: NoData()),
            loading: () => SliverFillRemaining(hasScrollBody: false, child: const Center(child: CircularProgressIndicator()))
          ),

          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom))
        ]
      )
    );
  }
}