import 'package:flutter/material.dart';
import 'package:klicum/presentation/widgets/widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final displayMediumStyle = Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
    final displaySmallStyle = Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);    final bodyMediumStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle();

    final labelSmallStyle = Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600) ?? const TextStyle(fontWeight: FontWeight.w600);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mi Perfil', style: displaySmallStyle),
          const SizedBox(height: 20),
          Text('Usuario', style: subtitleStyle),
          Text('Leonardo', style: bodyMediumStyle),
          const SizedBox(height: 10),
          Text('Correo Electronico', style: subtitleStyle),
          Text('usuario0@gmail.com', style: bodyMediumStyle),
          const SizedBox(height: 10),
          Text('Balance', style: subtitleStyle),
          Text('145€', style: displayMediumStyle),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: screenHeight * 0.05,
                width: screenWidth * 0.425,
                child: Button(
                  callback: (){}, 
                  text: 'Recargar Saldo',
                  style: labelSmallStyle.copyWith(color: Colors.black)
                )
              ),
              SizedBox(
                height: screenHeight * 0.05,
                width: screenWidth * 0.425,
                child: Button(
                  callback: (){}, 
                  text: 'Cerrar Sesión',
                  style: labelSmallStyle.copyWith(color: Colors.white),
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  borderColor: Colors.white.withValues(alpha: 0.15)
                )
              )
            ]
          ),
          const SizedBox(height: 20),
          Text('Mis Rifas', style: subtitleStyle),
          const SizedBox(height: 10),
          SizedBox(
            height: (screenHeight * 0.125) + 32,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              separatorBuilder: (context, index) => SizedBox(width: screenWidth * 0.05),
              itemBuilder: (context, index) => MyRaffleCard()
            )
          ),
          const SizedBox(height: 20),
          Text('Mis Pedidos', style: subtitleStyle),
      
          ...List.generate(
            10, 
            (index) => MyOrderCard()
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom)
        ]
      )
    );
  }
}