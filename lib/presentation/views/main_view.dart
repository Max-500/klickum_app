import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/widgets.dart';

class MainView extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainView({super.key, required this.navigationShell});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Widget _navIcon({
    required IconData icon,
    required bool selected,
    required double containerSize,
    required double iconSize,
  }) {
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? Colors.white : Colors.white.withValues(alpha: 0.05),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: iconSize,
        color: selected ? Colors.black : Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    // Layout system (mismo padding que tu Positioned)
    final horizontalPadding = screenWidth * 0.05;

    // Responsivo (tablet >= 600)
    final isTablet = screenWidth >= 600;

    // Tamaños responsivos (puedes ajustar a gusto)
    final navHeight = isTablet ? 72.0 : 64.0;

    // Círculo e icono responsivos (con clamp para que nunca se pase)
    final iconContainerSize = (screenWidth * (isTablet ? 0.06 : 0.10)).clamp(40.0, 56.0).toDouble();
    final iconSize = (iconContainerSize * 0.55).clamp(20.0, 30.0).toDouble();

    // Margen inferior responsivo
    final bottomMargin = (screenHeight * 0.025).clamp(12.0, 28.0).toDouble();

    // Helper para escoger outlined vs filled según selected
    IconData iconFor(bool selected, IconData outlined, IconData filled) => selected ? filled : outlined;
    
    return PopScope(
      canPop: widget.navigationShell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (widget.navigationShell.currentIndex != 0) {
          widget.navigationShell.goBranch(0);
          return;
        }
      },
      child: Scaffold(
        extendBody: true,
        body: GestureDetector(
          child: Stack(
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
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: 0,
                child: widget.navigationShell,
              ),
            ],
          ),
        ),
        bottomNavigationBar: widget.navigationShell.currentIndex == 1 ? null : SafeArea(
          minimum: const EdgeInsets.only(bottom: 12),
          child: Container(
            margin: EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: bottomMargin,
            ),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(8, 13, 0, 0.9),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: NavigationBar(
                height: navHeight,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                elevation: 0,
      
                selectedIndex: widget.navigationShell.currentIndex,
                onDestinationSelected: (index) {
                    final isSameTab = index == widget.navigationShell.currentIndex;
                    widget.navigationShell.goBranch(index, initialLocation: isSameTab
                  );
                },
      
                // Quitamos el pill default: tu círculo es el indicador
                indicatorColor: Colors.transparent,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      
                destinations: [
                  NavigationDestination(
                    icon: _navIcon(
                      icon: iconFor(
                        widget.navigationShell.currentIndex == 0,
                        Icons.home_outlined,
                        Icons.home,
                      ),
                      selected: widget.navigationShell.currentIndex == 0,
                      containerSize: iconContainerSize,
                      iconSize: iconSize,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: _navIcon(
                      icon: iconFor(
                        widget.navigationShell.currentIndex == 2,
                        Icons.redeem_outlined,
                        Icons.redeem,
                      ),
                      selected: widget.navigationShell.currentIndex == 2,
                      containerSize: iconContainerSize,
                      iconSize: iconSize,
                    ),
                    label: 'Canje',
                  ),
                  NavigationDestination(
                    icon: _navIcon(
                      icon: iconFor(
                        widget.navigationShell.currentIndex == 3,
                        Icons.shopping_cart_outlined,
                        Icons.shopping_cart,
                      ),
                      selected: widget.navigationShell.currentIndex == 3,
                      containerSize: iconContainerSize,
                      iconSize: iconSize
                    ),
                    label: 'Carrito'
                  ),
                  NavigationDestination(
                    icon: _navIcon(
                      icon: iconFor(
                        widget.navigationShell.currentIndex == 4,
                        Icons.person_outline,
                        Icons.person
                      ),
                      selected: widget.navigationShell.currentIndex == 4,
                      containerSize: iconContainerSize,
                      iconSize: iconSize
                    ),
                    label: 'Perfil',
                  )
                ]
              )
            )
          )
        )
      ),
    );
  }
}
