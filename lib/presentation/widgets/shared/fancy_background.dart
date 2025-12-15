import 'dart:ui';
import 'package:flutter/material.dart';

class FancyBackground extends StatelessWidget {
  const FancyBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    final blobWidth = screenWidth * 0.80;
    final blobHeight = screenHeight * 0.30;

    return Stack(
      children: [
        // 🎨 Fondo base
        Container(color: Colors.black),

        // 🟢 Blob #9ACD32 (Layer Blur), centrado y oculto 90%
        Positioned(
          // 90% oculto en vertical → solo se ve 15% de su alto
          top: -(blobHeight * 0.85),
          left: (screenWidth - blobWidth) / 2,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(
              width: blobWidth,
              height: blobHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF9ACD32),
                borderRadius: BorderRadius.circular(blobHeight), // forma suave tipo “mancha”
              ),
            ),
          ),
        ),
      ],
    );
  }
}
