import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/presentation/providers/products_provider.dart';
import 'package:klicum/presentation/widgets/shared/no_data.dart';
import 'package:klicum/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final scrollController = ScrollController();


  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (!mounted) return;

      final max = scrollController.position.maxScrollExtent;
      final offset = scrollController.offset;

      if (offset >= max - 300) ref.read(productsProvider.notifier).loadMoreProducts();
    });

  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final displaySmallStyle = Theme.of(context).textTheme.displaySmall ?? const TextStyle();

    final titleStyle = Theme.of(context).textTheme.titleLarge ?? const TextStyle();

    final colors = Theme.of(context).colorScheme;

    ref.listen(productsProvider, (previous, next) => next.whenOrNull(
      error: (error, stackTrace) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
          Helper.getSnackbar(
            color: Helper.isNetworkError(error) ? colors.tertiary : colors.error,
            isWarning: Helper.isNetworkError(error),
            text: Helper.isNetworkError(error) ? 'Sin conexion a internet' : Helper.normalizeError(error),
            duration: Helper.isNetworkError(error) ? const Duration(days: 1) : null,
            callback: () {}
          )        
        );
      }
    ));

    ref.listen(loadMoreProductsErrorProvider, (prev, next) {
      if (!mounted) return;
      if (next == null) return;
      ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
        Helper.getSnackbar(
          color: Helper.isNetworkError(next) ? colors.tertiary : colors.error,
          isWarning: Helper.isNetworkError(next),
          text: Helper.isNetworkError(next) ? 'Sin Conexión a Internet' : Helper.normalizeError(next),
          duration: Helper.isNetworkError(next) ? const Duration(days: 1) : null,
          callback: () {}
        )
      );
    });

    final asyncProducts = ref.watch(productsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        try {
          ref.invalidate(productsProvider);
          await ref.read(productsProvider.future);
        // ignore: empty_catches
        } catch (e) {}
      },
      child: CustomScrollView(
        controller: scrollController,
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
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                separatorBuilder: (context, index) => SizedBox(width: screenWidth * 0.05),
                itemBuilder: (context, index) => RaffleCard()
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