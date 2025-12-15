import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/widgets.dart';

class MainView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainView({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        child: Stack(
          children: [
            const FancyBackground(),

            Positioned(
              top: screenHeight * 0.05,
              child: SizedBox(
                width: screenWidth,
                child: Center(
                  child: MyTitle()
                )
              )
            ),

            navigationShell
          ]
        )
      )
    );
  }
}