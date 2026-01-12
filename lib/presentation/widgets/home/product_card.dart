import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/config/constants/types.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/domain/entities/product.dart';
import 'package:klicum/presentation/providers/cart_provider.dart';
import '../widgets.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, ref) {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final bodyLargeStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white);
    final bodySmallStyle = Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w200) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200);

    final labelMediumStyle = Theme.of(context).textTheme.labelMedium?.copyWith(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600) ?? const TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600);

    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(15)
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  product.image,
                  fit: BoxFit.cover,
                )
              ]
            )
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(product.name, style: bodyLargeStyle)
          ),

          const SizedBox(height: 5),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              product.description,
              style: bodySmallStyle
            )
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('${product.price}€', style: titleStyle, textAlign: TextAlign.end)
              )
            ]
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Button(
                  callback: product.productStatus == ProductStatus.available ? () {
                    if (product.variants.isEmpty) return;
                    if (product.variants.length == 1) {
                      ref.read(myCartProvider.notifier).addProduct(product.variants.first, product.price, product.name);
                    } else {
                      showModalBottomSheet(
                        context: context, 
                        isScrollControlled: true,
                        useRootNavigator: true,
                        backgroundColor: AppStyle.backgroundColor,
                        builder: (context) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...product.variants.map((variant) => Column(
                                children: [
                                  SizedBox(height: 20),
                                  InputTile(
                                    title: variant.size!,
                                    focusedBorderColor: AppStyle.primaryColor,
                                    onTap: () {
                                      ref.read(myCartProvider.notifier).addProduct(variant, product.price, product.name);
                                      context.pop();
                                    }
                                  )
                                ]
                              )),
                              SizedBox(height: MediaQuery.of(context).padding.bottom)
                            ]
                          )
                        ));
                    }
                  } : null,
                  text: product.productStatus == ProductStatus.available ?  'Añadir Carrito' : 'No hay Stock',
                  style: labelMediumStyle.copyWith(color: product.productStatus == ProductStatus.available ?Colors.black : Colors.white),
                  backgroundColor: product.productStatus == ProductStatus.available ? null : Color.fromRGBO(123, 35, 17, 1)
                )
              ),
            ],
          ),

          const SizedBox(height: 10)
        ]
      )
    );
  }
}