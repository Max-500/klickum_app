import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/config/constants/types.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/domain/entities/order.dart';

class MyOrderCard extends StatelessWidget {
  final Order order;

  const MyOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);
    final miniTitleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white) ?? const TextStyle();


    return GestureDetector(
      onTap: () => context.push('/order', extra: order),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppStyle.primaryColor.withValues(alpha: 0),
                  AppStyle.primaryColor.withValues(alpha: 0.1),
                  AppStyle.primaryColor.withValues(alpha: 0.1)
                ],
                stops: const [0.0, 0.5, 1.0]
              ),
              border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.15)),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Productos', style: subtitleStyle),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: order.status.color,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Text(order.status.labelEs, style: subtitleStyle.copyWith(color: Color.fromRGBO(8, 13, 0, 1), fontWeight: FontWeight.normal)),
                    )
                  ]
                ),
                const SizedBox(height: 10),
                ...order.products.map((product) => Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text('${product.name} x ${product.amount}', style: miniTitleStyle)
                )),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(Helper.formatFecha(order.updatedAt), style: subtitleStyle),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Total', style: subtitleStyle),
                        Text('${order.total.toStringAsFixed(2)}€', style: miniTitleStyle)
                      ]
                    )
                  ]
                )
              ]
            )
          ),
          
          const SizedBox(height: 20)
        ]
      ),
    );
  }
}