import 'dart:ui';

import 'package:flutter/material.dart';

class FancyBackground extends StatelessWidget {
  const FancyBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color.fromRGBO(8, 13, 0, 1)),
        Positioned(top: -160, left: -100, child: _greenBlob()),
        Positioned(bottom: -160, left: -100, child: _greenBlob()),
        Positioned(bottom: -160, right: -100, child: _greenBlob()),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.25,
          left: -150,
          child: Container(
            width: MediaQuery.of(context).size.width * 1.4,
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(15, 25, 5, 1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 70,
          right: -20,
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(170, 110, 20, 1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(
              color: Colors.black.withValues(alpha: 0.10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _greenBlob() => Container(
        width: 300,
        height: 300,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(70, 100, 20, 1),
        ),
      );
}
