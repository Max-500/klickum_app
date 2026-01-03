import 'package:flutter/material.dart';
import 'package:klicum/config/constants/types.dart';
import 'package:klicum/domain/entities/product.dart';
import '../widgets.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final bodyLargeStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white);
    final bodySmallStyle = Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w200) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200);

    final labelMediumStyle = Theme.of(context).textTheme.labelMedium?.copyWith(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600) ?? const TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600);

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
                  callback: product.productStatus == ProductStatus.available ? () async {
                    
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