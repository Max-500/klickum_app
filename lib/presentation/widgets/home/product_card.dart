import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/config/constants/types.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/domain/entities/presentation/cart_product.dart';
import 'package:klicum/domain/entities/product.dart';
import 'package:klicum/presentation/providers/repositories/cart_repository_provider.dart';
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

    final colors = Theme.of(context).colorScheme;

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
                  loadingBuilder: (context, child, loadingProgress) => loadingProgress == null ? child : ImageCardSkeleton(),
                  errorBuilder: (_, _, _) => GenericErrorImage()
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
            child: Text(product.description, style: bodySmallStyle)
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Button(
                    callback: product.productStatus == ProductStatus.available ? () async {
                      try {
                        if (product.variants.isEmpty) return;
                        if (product.productType == ProductType.digital) {
                          context.push('/select-address', extra: {
                            product.variants.first.id: CartProduct(name: product.name, amount: 1, variant: product.variants.first, price: product.price, id: '')
                          });
                          return;
                        }
                        if (product.variants.length == 1) {
                          if (product.variants.first.amount <= 0) {
                            ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                              Helper.getSnackbar(
                                color: colors.tertiary,
                                isWarning: true,
                                isSuccess: false,
                                text: 'Actualmente el producto no tiene existencia en Stock',
                                duration: const Duration(seconds: 5)
                              )
                            );
                            return;
                          }
                          await ref.read(cartRepositoryProvider).addVariant(productVariantID: product.variants.first.id, amount: 1);
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
                                        onTap: () async {
                                          try {
                                            if (variant.amount <= 0) {
                                              ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                                                Helper.getSnackbar(
                                                  color: colors.tertiary,
                                                  isWarning: true,
                                                  isSuccess: false,
                                                  text: 'Actualmente el producto no tiene existencia en Stock',
                                                  duration: const Duration(seconds: 5)
                                                )
                                              );
                                              return;
                                            }
                                            await ref.read(cartRepositoryProvider).addVariant(productVariantID: product.variants.first.id, amount: 1);
                                            if (context.mounted) context.pop();
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                                                Helper.getSnackbar(
                                                  color: colors.primary,
                                                  isWarning: false,
                                                  isSuccess: true,
                                                  text: 'Producto añadido correctamente',
                                                  duration: const Duration(seconds: 5)
                                                )
                                              );
                                            }
                                          } catch (error) {
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                                              Helper.getSnackbar(
                                                color: Helper.isNetworkError(error) ? colors.tertiary : colors.error,
                                                isWarning: Helper.isNetworkError(error),
                                                text: Helper.isNetworkError(error) ? 'Sin conexion a internet' : Helper.normalizeError(error),
                                                duration: Helper.isNetworkError(error) ? const Duration(days: 1) : const Duration(seconds: 5)
                                              )
                                            );
                                          }
                                        }
                                      )
                                    ]
                                  )),
                                  SizedBox(height: MediaQuery.of(context).padding.bottom)
                                ]
                              )
                            ));
                        }
                        if (!context.mounted) return;
                        
                        ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                          Helper.getSnackbar(
                            color: colors.primary,
                            isWarning: false,
                            isSuccess: true,
                            text: 'Producto añadido correctamente',
                            duration: const Duration(seconds: 5)
                          )
                        );
                      } catch (error) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                          Helper.getSnackbar(
                            color: Helper.isNetworkError(error) ? colors.tertiary : colors.error,
                            isWarning: Helper.isNetworkError(error),
                            text: Helper.isNetworkError(error) ? 'Sin conexion a internet' : Helper.normalizeError(error),
                            duration: Helper.isNetworkError(error) ? const Duration(days: 1) : const Duration(seconds: 5)
                          )
                        );
                      }
                    } : null,
                    text: product.productStatus == ProductStatus.available ?  'Añadir' : 'No hay Stock',
                    style: labelMediumStyle.copyWith(color: product.productStatus == ProductStatus.available ?Colors.black : Colors.white),
                    backgroundColor: product.productStatus == ProductStatus.available ? null : Color.fromRGBO(123, 35, 17, 1)
                  )
                )
              )
            ]
          ),

          const SizedBox(height: 10)
        ]
      )
    );
  }
}