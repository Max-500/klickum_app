import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/presentation/providers/cart_provider.dart';
import 'package:klicum/presentation/providers/products_provider.dart';
import '../widgets/widgets.dart';

class CartView extends ConsumerWidget {

  const CartView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final displayMediumStyle = Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
    final displaySmallStyle = Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);

    final bodyMediumStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white);
    
    final labelLargeStyle = Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.black, fontWeight: FontWeight.w600);

    final cartProducts = ref.watch(myCartProvider);
    final asyncProducts = ref.watch(productProvider);

    final total = cartProducts.values.fold<double>(
      0.0,
      (sum, item) => sum + item.amount * item.price,
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mi Carrito', style: displaySmallStyle),
              const SizedBox(height: 20)
            ]
          )
        ),

        SliverList.builder(
          itemBuilder: (context, index) => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Text('${cartProducts.entries.elementAt(index).value.name} (${cartProducts.entries.elementAt(index).value.price.toStringAsFixed(2)}€) ${cartProducts.entries.elementAt(index).value.variant.size}', style: bodyMediumStyle)
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => ref.read(myCartProvider.notifier).decrement(cartProducts.entries.elementAt(index).value.variant.id), 
                      icon: Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: const CircleBorder()
                      )
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: screenWidth * 0.075,
                      child: Text(
                        cartProducts.entries.elementAt(index).value.amount.toString(),
                        maxLines: 1000,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: bodyMediumStyle,
                      ),
                    ),

                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () => ref.read(myCartProvider.notifier).addProduct(cartProducts.entries.elementAt(index).value.variant, null, null), 
                      icon: Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: const CircleBorder()
                      )
                    )
                  ]
                )
              )
            ],
          ),
          itemCount: cartProducts.length,
        ),

        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.025),
              Text('Total', style: bodyMediumStyle),
              Text('${total.toStringAsFixed(2)}€', style: displayMediumStyle),
              const SizedBox(height: 20)
            ]
          )
        ),

        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.05,
                width: double.infinity,
                child: Button(
                  callback: () {
                    if (cartProducts.isNotEmpty) context.push('/select-address', extra: true);
                  },
                  text: 'Realizar Pedido', 
                  style: labelLargeStyle
                )
              ),
              SizedBox(height: screenHeight * 0.025),
              Text('Productos Relacionados', style: subtitleStyle),
              const SizedBox(height: 10),
            ]
          )
        ),
        
        asyncProducts.when(
          data: (data) => data.isEmpty
            ? SliverToBoxAdapter(child: NoData(msg: 'No hay productos disponibles',))
            : SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childCount: data.length,
                itemBuilder: (context, index) => ProductCard(product: data[index]),
              ),
          error: (error, stackTrace) => SliverToBoxAdapter(child: NoData()),
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
    );
  }
}