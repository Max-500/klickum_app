import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/presentation/widgets/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final displaySmallStyle = Theme.of(context).textTheme.displaySmall ?? const TextStyle();

    final titleStyle = Theme.of(context).textTheme.titleLarge ?? const TextStyle();

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
            itemBuilder: (context, index) => RaffleCard()
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
              children: const [
                ProductCard(),
                Spacer(),
                ProductCard()
              ]
            )
          )
        ),

        SizedBox(height: MediaQuery.of(context).padding.bottom)
      ]
    );
  }
}