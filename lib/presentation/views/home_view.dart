import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final displaySmallStyle = Theme.of(context).textTheme.displaySmall ?? const TextStyle();

    final titleStyle = Theme.of(context).textTheme.titleLarge ?? const TextStyle();
    final subtitleStyle = Theme.of(context).textTheme.titleMedium ?? const TextStyle();
    final miniTitle = Theme.of(context).textTheme.titleSmall ?? const TextStyle();

    final bodyLargeStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    final bodySmallStyle = Theme.of(context).textTheme.bodySmall ?? const TextStyle();

    final labelSmallStyle = Theme.of(context).textTheme.labelSmall ?? const TextStyle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Hola ', style: displaySmallStyle.copyWith(color: Colors.white)),
            Text('Leonardo', style: displaySmallStyle.copyWith(color: AppStyle.primaryColor))
          ]
        ),

        const SizedBox(height: 20),

        Text('Rifas', style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200)),

        const SizedBox(height: 10),

        SizedBox(
          height: (screenHeight * 0.125) + 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            separatorBuilder: (context, index) => SizedBox(width: screenWidth * 0.05),
            itemBuilder: (context, index) => Container(
              height: screenHeight * 0.125,
              width: screenWidth * 0.5,
              constraints: BoxConstraints(maxHeight: screenHeight * 0.125),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppStyle.primaryColor.withValues(alpha: 0),
                    AppStyle.primaryColor.withValues(alpha: 0.1),
                    AppStyle.primaryColor.withValues(alpha: 0.1),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.15)),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('90 Números', style: subtitleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200)),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('8.5€', style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                          Text('/ Nro', style: miniTitle.copyWith(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w200))
                        ]
                      )
                    ] 
                  ),
                  const Spacer(),
                  Text('Premio', style: miniTitle.copyWith(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w200)),
                  Text('Galaxy S24', style: bodyLargeStyle.copyWith(color: Colors.white))
                ]
              )
            )
          )
        ),

        const SizedBox(height: 20),

        Text('Productos', style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200)),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            itemCount: 2,
            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
            separatorBuilder: (context, index) => SizedBox(height: screenHeight * 0.02),
            itemBuilder: (context, index) => Row(
              children: [
                Container(
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
                                child: Image.network('https://i.pinimg.com/736x/d7/8f/cd/d78fcd7e56e368782c00160289e3e46a.jpg', fit: BoxFit.cover)
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
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    'Hechicero Especial', 
                                    style: labelSmallStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis), 
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  )
                                )
                              )
                            ]
                          )
                        ),
                        SizedBox(height: constraints.maxHeight * 0.015),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                          child: Text('Suguru Geto', style: bodyLargeStyle.copyWith(color: Colors.white)),
                        ), // Flex 1
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                            child: Text('Pilar del mundo de la hechiceria y mejor amigo de Satoru Gojo', 
                              style: bodySmallStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                            ),
                          )
                        ), // Flex 4
                        Padding(
                          padding: EdgeInsets.only(right: constraints.maxWidth * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text('4.99€', style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600))]
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty .resolveWith((states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return AppStyle.primaryColor.withValues(alpha: 0.8);
                                }
                                return AppStyle.primaryColor;
                              }),
                                  shape: WidgetStateProperty .all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            onPressed: (){}, 
                            child: Text('Añadir al Carrito', style: labelSmallStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w600),))
                        ),
                        SizedBox(height: constraints.maxHeight * 0.025),
                      ]
                    )
                  ),
                ),
                const Spacer(),
                Container(
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
                                child: Image.network('https://i.pinimg.com/736x/d7/8f/cd/d78fcd7e56e368782c00160289e3e46a.jpg', fit: BoxFit.cover)
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
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    'Hechicero Especial', 
                                    style: labelSmallStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis), 
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  )
                                )
                              )
                            ]
                          )
                        ),
                        SizedBox(height: constraints.maxHeight * 0.015),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                          child: Text('Suguru Geto', style: bodyLargeStyle.copyWith(color: Colors.white)),
                        ), // Flex 1
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                            child: Text('Pilar del mundo de la hechiceria y mejor amigo de Satoru Gojo', 
                              style: bodySmallStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                            ),
                          )
                        ), // Flex 4
                        Padding(
                          padding: EdgeInsets.only(right: constraints.maxWidth * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text('4.99€', style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600))]
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty .resolveWith((states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return AppStyle.primaryColor.withValues(alpha: 0.8);
                                }
                                return AppStyle.primaryColor;
                              }),
                                  shape: WidgetStateProperty .all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            onPressed: (){}, 
                            child: Text('Añadir al Carrito', style: labelSmallStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w600),))
                        ),
                        SizedBox(height: constraints.maxHeight * 0.025),
                      ]
                    )
                  ),
                )
              ]
            )
          )
        ),

        SizedBox(height: MediaQuery.of(context).padding.bottom)
      ]
    );
  }
}