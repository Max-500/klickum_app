import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';

class MyOrderCard extends StatelessWidget {
  const MyOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ['Zapatillas x 1', 'Zapatillas x 1', 'Zapatillas x 1'];

    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);
    final miniTitleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white) ?? const TextStyle();


    return Column(
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
                      color: Color.fromRGBO(242, 132, 5, 1),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Text('Pendiente', style: subtitleStyle.copyWith(color: Color.fromRGBO(8, 13, 0, 1), fontWeight: FontWeight.normal)),
                  )
                ]
              ),
              const SizedBox(height: 10),
              ...data.map((e) => Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(e, style: miniTitleStyle)
              )),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('17/07/2025 - 16:45', style: subtitleStyle),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Total', style: subtitleStyle),
                      Text('8.5€', style: miniTitleStyle)
                    ]
                  )
                ]
              )
            ]
          )
        ),
        
        const SizedBox(height: 20)
      ]
    );
  }
}