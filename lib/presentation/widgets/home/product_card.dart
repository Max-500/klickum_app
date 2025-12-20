import 'package:flutter/material.dart';
import '../widgets.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis);

    final bodyLargeStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis);
    final bodySmallStyle = Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);

    final labelSmallStyle = Theme.of(context).textTheme.labelSmall?.copyWith(overflow: TextOverflow.ellipsis) ?? const TextStyle(overflow: TextOverflow.ellipsis);

    return Container(
      width: screenWidth * 0.425,
      height: screenHeight * 0.4,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight * 0.5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      'https://i.pinimg.com/736x/d7/8f/cd/d78fcd7e56e368782c00160289e3e46a.jpg',
                      fit: BoxFit.cover
                    )
                  ),

                  Positioned(
                    top: constraints.maxHeight * 0.5 * 0.12,
                    left: constraints.maxWidth * 0.06,
                    child: Container(
                      width: constraints.maxWidth * 0.5,
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.05,
                        vertical: constraints.maxHeight * 0.5 * 0.06,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(8, 13, 0, 1),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Hechicero Especial',
                        style: labelSmallStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w200,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.015),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
              child: Text(
                'Suguru Geto',
                style: bodyLargeStyle,
                maxLines: 2
              )
            ), // Flex 1
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                child: Text(
                  'Pilar del mundo de la hechiceria y mejor amigo de Satoru Gojo',
                  style: bodySmallStyle,
                  maxLines: 3,
                  textAlign: TextAlign.left
                )
              )
            ), // Flex 4

            Padding(
              padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Text('4.99€', style: titleStyle, textAlign: TextAlign.end))
                ]
              )
            ),

            const SizedBox(height: 5),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
              child: Center(
                child: Button(callback: (){}, text: 'Añadir Carrito', style: labelSmallStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w600))
              )
            ),
            SizedBox(height: constraints.maxHeight * 0.025)
          ]
        )
      )
    );
  }
}