import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/domain/entities/address.dart';
import 'package:klicum/presentation/providers/address_provider.dart';
import 'package:klicum/presentation/providers/cart_provider.dart';
import 'package:klicum/presentation/providers/products_provider.dart';
import 'package:klicum/presentation/widgets/shared/no_data.dart';
import '../widgets/widgets.dart';

class CartView extends ConsumerWidget {
  Address? addressSelected;

  CartView({super.key});

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
      (sum, item) => sum + item.amount * item.product.price,
    );

    final asyncAddress = ref.watch(addressProvider);

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
                child: Text(cartProducts.entries.elementAt(index).value.product.name, style: bodyMediumStyle)
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => ref.read(myCartProvider.notifier).decrement(cartProducts.entries.elementAt(index).value.product.id), 
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
                      onPressed: () => ref.read(myCartProvider.notifier).increment(cartProducts.entries.elementAt(index).value.product.id), 
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
                  callback: () async {
                    if (cartProducts.isEmpty) return;
                    context.push('/select-address');
                    return;
                    final address = asyncAddress.value ?? [];
                    if (address.isEmpty) {
                      context.push('/address');
                      return;
                    }

                    if (addressSelected != null) {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: true, 
                        backgroundColor: AppStyle.backgroundColor,
                        builder: (context) => SafeArea(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              20,
                              16,
                              16,
                              16 + MediaQuery.of(context).padding.bottom,
                            ),
                            child: Column(
                              children: [
                                const Spacer(), // ✅ empuja hacia abajo

                                SizedBox(
                                  height: screenHeight * 0.075,
                                  width: double.infinity,
                                  child: Button(
                                    callback: () {
                                      // confirmar pedido
                                      context.pop(addressSelected); // si quieres devolverla
                                    },
                                    text: '¿Estás seguro? El pedido se enviará a ${addressSelected!.streetName}',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: screenHeight * 0.05,
                                  width: double.infinity,
                                  child: SizedBox(
                                  height: screenHeight * 0.075,
                                  width: double.infinity,
                                  child: Button(
                                    callback: () {
                                      addressSelected = null;
                                      context.pop(addressSelected); // si quieres devolverla
                                    },
                                    text: 'Cambiar direccion',
                                  ),
                                ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                      await showModalBottomSheet(
                        context: context, 
                        isScrollControlled: true,
                        useRootNavigator: true,
                        backgroundColor: AppStyle.backgroundColor,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.85,
                          minChildSize: 0.35,
                          maxChildSize: 0.95,
                          builder: (context, scrollController) => Container(
                            decoration: BoxDecoration(
                              color: AppStyle.backgroundColor,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                            ),
                            child: SafeArea(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ListView.separated(
                                        controller: scrollController,
                                        itemCount: address.length,
                                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                                        itemBuilder: (context, index) {
                                          final isSelected = address[index].id == addressSelected?.id;
                                          return InkWell(
                                            borderRadius: BorderRadius.circular(20),
                                            onTap: () {
                                              addressSelected = address[index];
                                              context.pop();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(color: isSelected ? AppStyle.primaryColor : Colors.white.withAlpha(45), width: 1),
                                                color: Colors.white.withAlpha(15)
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 2),
                                                    child: Icon(
                                                      isSelected
                                                          ? Icons.radio_button_checked
                                                          : Icons.radio_button_unchecked,
                                                      color: isSelected ? AppStyle.primaryColor : Colors.white.withValues(alpha: 0.45),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Dirección: ${address[index].streetName}', style: TextStyle(color: Colors.white),),
                                                        Text('Número: ${address[index].streetNumber}', style: TextStyle(color: Colors.white),),
                                                        Text('Ciudad: ${address[index].city}', style: TextStyle(color: Colors.white),),
                                                        Text('País: ${address[index].country}', style: TextStyle(color: Colors.white),),
                                                        Text('Código Postal: ${address[index].zipCode}', style: TextStyle(color: Colors.white),)
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          );
                                        }
                                      )
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: screenHeight * 0.05,
                                      width: screenWidth * 0.9,
                                      child: Button(callback: () => context.push('/address'), text: 'Añadir Dirección')
                                    )
                                  ]
                                )
                              )
                            )
                          )
                        )
                      );
                    } else {
                      await showModalBottomSheet(
                        context: context, 
                        isScrollControlled: true,
                        useRootNavigator: true,
                        backgroundColor: AppStyle.backgroundColor,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.85,
                          minChildSize: 0.35,
                          maxChildSize: 0.95,
                          builder: (context, scrollController) => Container(
                            decoration: BoxDecoration(
                              color: AppStyle.backgroundColor,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                            ),
                            child: SafeArea(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ListView.separated(
                                        controller: scrollController,
                                        itemCount: address.length,
                                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                                        itemBuilder: (context, index) {
                                          final isSelected = address[index].id == addressSelected?.id;
                                          return InkWell(
                                            borderRadius: BorderRadius.circular(20),
                                            onTap: () {
                                              addressSelected = address[index];
                                              context.pop();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(color: isSelected ? AppStyle.primaryColor : Colors.white.withAlpha(45), width: 1),
                                                color: Colors.white.withAlpha(15)
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 2),
                                                    child: Icon(
                                                      isSelected
                                                          ? Icons.radio_button_checked
                                                          : Icons.radio_button_unchecked,
                                                      color: isSelected ? AppStyle.primaryColor : Colors.white.withValues(alpha: 0.45),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Dirección: ${address[index].streetName}', style: TextStyle(color: Colors.white),),
                                                        Text('Número: ${address[index].streetNumber}', style: TextStyle(color: Colors.white),),
                                                        Text('Ciudad: ${address[index].city}', style: TextStyle(color: Colors.white),),
                                                        Text('País: ${address[index].country}', style: TextStyle(color: Colors.white),),
                                                        Text('Código Postal: ${address[index].zipCode}', style: TextStyle(color: Colors.white),)
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          );
                                        }
                                      )
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: screenHeight * 0.05,
                                      width: screenWidth * 0.9,
                                      child: Button(callback: () => context.push('/address'), text: 'Añadir Dirección')
                                    )
                                  ]
                                )
                              )
                            )
                          )
                        )
                      );
                    }
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
            ? SliverToBoxAdapter(child: NoData())
            : SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childCount: data.length,
                itemBuilder: (context, index) => ProductCard(product: data[index]),
              ),
          error: (error, stackTrace) => SliverToBoxAdapter(child: NoData()),
          loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator())
          )
        ),

        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom))
      ]
    );
  }
}