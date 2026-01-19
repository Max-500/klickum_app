import 'package:flutter/material.dart';

class GenericErrorImage extends StatelessWidget {
  const GenericErrorImage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.isFinite ? constraints.maxWidth : 100;
        final h = constraints.maxHeight.isFinite ? constraints.maxHeight : 100;
        final minSide = (w < h) ? w : h;

        final iconSize = (minSide * 0.35).clamp(24.0, 64.0);
        final titleSize = (minSide * 0.12).clamp(10.0, 14.0);
        final padding = (minSide * 0.10).clamp(8.0, 14.0);
        final spacing = (minSide * 0.06).clamp(6.0, 10.0);

        return Container(
          color: const Color(0xFF242424),
          alignment: Alignment.center,
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                size: iconSize,
                color: Colors.white.withAlpha(35),
              ),
              SizedBox(height: spacing),
              Text(
                'Imagen no disponible',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withAlpha(65)
                )
              )
            ]
          )
        );
      }
    );
  }
}