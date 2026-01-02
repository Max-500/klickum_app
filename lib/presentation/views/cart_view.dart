import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class CartView extends StatelessWidget {
  static const List<String> elements = ['Suguru Geto (4.99€)', 'Satoru Gojo(4.99€)'];

  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final displayMediumStyle = Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
    final displaySmallStyle = Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);

    final bodyMediumStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white);
    
    final labelLargeStyle = Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.black, fontWeight: FontWeight.w600);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mi Carrito', style: displaySmallStyle),
        const SizedBox(height: 20),
        ...elements.map((e) => Row(
          children: [
            Text(e, style: bodyMediumStyle),
            const Spacer(),
            IconButton(onPressed: (){}, icon: Icon(Icons.remove)),
            SizedBox(width: screenWidth * 0.025),
            Text('1', style: bodyMediumStyle),
            SizedBox(width: screenWidth * 0.025),
            IconButton(onPressed: (){}, icon: Icon(Icons.add))
          ]
        )),
        SizedBox(height: screenHeight * 0.025),
        Text('Total', style: bodyMediumStyle),
        Text('9.98€', style: displayMediumStyle),
        const SizedBox(height: 20),
        SizedBox(
          height: screenHeight * 0.05,
          width: double.infinity,
          child: Button(callback: (){}, text: 'Realizar Pedido', style: labelLargeStyle)
        ),
        SizedBox(height: screenHeight * 0.025),
        Text('Productos Relacionados', style: subtitleStyle),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            itemCount: 2,
            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
            separatorBuilder: (context, index) => SizedBox(height: screenHeight * 0.02),
            itemBuilder: (context, index) => Row(
              children: const [
                // ProductCard(title: '',),
                Spacer(),
                // ProductCard(title: '',)
              ]
            )
          )
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom)
      ]
    );
  }
}