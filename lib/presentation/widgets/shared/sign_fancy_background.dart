import 'dart:ui';

import 'package:flutter/material.dart';

class SignFancyBackground extends StatelessWidget {
  const SignFancyBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Tamaño del blob = 3/4 del ancho
    final double blobSize = size.width * 0.75;

    return Stack(
      children: [
        // Fondo base
        Container(color: Colors.black),

        // 🌿 Blob oculto SOLO a lo ancho (lateral), no hacia arriba
        Positioned(
          top: 0,
          left: -blobSize * 0.50,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 40,   // ajusta el nivel del blur
              sigmaY: 40,
            ),
            child: Container(
              width: blobSize,
              height: blobSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 28, 41, 10).withValues(alpha: 0.5),
              ),
            ),
          ),
        ),

        // 🌿 Blob 2 – Derecha, oculto a la mitad vertical
        Positioned(
          top: -blobSize * 0.50, // se esconde mitad hacia arriba
          right: -40,              // pegado al borde derecho
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 40,
              sigmaY: 40,
            ),
            child: Container(
              width: blobSize,
              height: blobSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(154, 205, 50, 0.5), // color que pediste
              ),
            ),
          ),
        ),

        // 🟠 Blob 3 – Naranja, desde el 10% de alto, pegado a la derecha,
        Positioned(
          top: size.height * 0.10, // empieza a partir del 10% de la altura
          right: 0,                 // pegado a la orilla derecha, sin ocultar
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              width: size.width * 0.33,
              height: blobSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(242, 135, 5, 0.5), // color naranja que pediste
              ),
            ),
          ),
        ),
        
        // 🟢 Blob 4 – Inferior derecha, mitad vertical oculta y 1/4 horizontal
        Positioned(
          bottom: -blobSize * 0.5,   // oculta la MITAD hacia abajo
          right: -blobSize * 0.25,   // oculta 1/4 hacia la derecha
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 40,
              sigmaY: 40,
            ),
            child: Container(
              width: blobSize,
              height: blobSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                // ARGB: 0x80 = 50% de opacidad
                color: Color(0x804F701B), // 50% opacity sobre #4F701B
              ),
            ),
          ),
        ),

        // 🟢 Blob 5 – Inferior izquierda, 50% opacity,
        // oculto mitad vertical y 6/10 horizontal
        Positioned(
          bottom: -blobSize * 0.50,   // oculta la MITAD hacia abajo
          left: -blobSize * 0.60,     // oculta 6/10 hacia la izquierda
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 40,
              sigmaY: 40,
            ),
            child: Container(
              width: blobSize,
              height: blobSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 28, 41, 10), // 50% opacity con withValues
              ),
            ),
          ),
        ),

      ],
    );
  }
}
