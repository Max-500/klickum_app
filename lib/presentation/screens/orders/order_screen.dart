import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/domain/entities/order.dart';
import '../../widgets/widgets.dart';

class OrderScreen extends StatelessWidget {
  final Order order;

  const OrderScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final displaySmallStyle = Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white);

    final headlineSmallStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppStyle.primaryColor, fontWeight: FontWeight.w600) ?? const TextStyle(color: AppStyle.primaryColor, fontWeight: FontWeight.w600);

    final bodyLargeStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
    final bodyMediumStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppStyle.primaryColor, fontWeight: FontWeight.w600) ?? const TextStyle(color: AppStyle.primaryColor, fontWeight: FontWeight.w600);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const FancyBackground(),

          Positioned(
            top: screenHeight * 0.05,
            child: SizedBox(
              width: screenWidth,
              child: Center(child: MyTitle()),
            ),
          ),

          Positioned(
            top: screenHeight * 0.125,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resumen de mi Orden', style: displaySmallStyle),
              
                  const SizedBox(height: 40),
              
                  Text('Productos', style: headlineSmallStyle),
              
                  const SizedBox(height: 20),
              
                  Container(
                    width: screenWidth * 0.9,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E150F),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withAlpha(8), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(45),
                          blurRadius: 18,
                          offset: const Offset(0, 10)
                        )
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...order.products.map((product) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, style: bodyLargeStyle),
                            Wrap(
                              spacing: 12,
                              runSpacing: 4,
                              children: [
                                Text('Cantidad: ', style: bodyMediumStyle.copyWith(color: Colors.white)),
                                Text(product.amount.toString(), style: bodyMediumStyle),
                                Text('Talla: ', style: bodyMediumStyle.copyWith(color: Colors.white)),
                                Text((product.variants.first.size ?? '').isEmpty ? '-' : product.variants.first.size!, style: bodyMediumStyle),
                                Text('Precio: ', style: bodyMediumStyle.copyWith(color: Colors.white)),
                                Text('${product.price.toStringAsFixed(2)}€', style: bodyMediumStyle),
                                Text('Total: ', style: bodyMediumStyle.copyWith(color: Colors.white)),
                                Text((product.amount * product.price).toStringAsFixed(2), style: bodyMediumStyle)
                              ]
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                          ]
                        )),
              
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total: ', style: bodyLargeStyle),
                            Text('${order.total.toStringAsFixed(2)}€', style: bodyLargeStyle.copyWith(color: AppStyle.primaryColor))
                          ]
                        )
                      ]
                    )
                  ),
              
                  const SizedBox(height: 20),
              
                  Text('Dirección de Envío', style: headlineSmallStyle),
              
                  const SizedBox(height: 20),
              
                  Container(
                    width: screenWidth * 0.9,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E150F),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withAlpha(8), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(45),
                          blurRadius: 18,
                          offset: const Offset(0, 10)
                        )
                      ]
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: AppStyle.primaryColor 
                          )
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dirección: ${order.address.streetName}', style: TextStyle(color: Colors.white)),
                              Text('Número: ${order.address.streetNumber}', style: TextStyle(color: Colors.white)),
                              Text('Ciudad: ${order.address.city}', style: TextStyle(color: Colors.white)),
                              Text('País: ${order.address.country}', style: TextStyle(color: Colors.white)),
                              Text('Código Postal: ${order.address.zipCode}', style: TextStyle(color: Colors.white))
                            ]
                          )
                        )
                      ]
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