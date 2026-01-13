import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/presentation/providers/user_provider.dart';
import 'package:klicum/presentation/widgets/widgets.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final displayMediumStyle = Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
    final displaySmallStyle = Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);    final bodyMediumStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle();

    final labelSmallStyle = Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600) ?? const TextStyle(fontWeight: FontWeight.w600);
    
    final asyncMe = ref.watch(meProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mi Perfil', style: displaySmallStyle),
          const SizedBox(height: 20),
          Text('Usuario', style: subtitleStyle),
          asyncMe.when(
            data: (me) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(me.username, style: bodyMediumStyle),
                const SizedBox(height: 10),
                Text('Correo Electronico', style: subtitleStyle),
                Text(me.email, style: bodyMediumStyle),
                const SizedBox(height: 10),
                Text('Balance', style: subtitleStyle),
                Text('${me.balance.toStringAsFixed(2)}€', style: displayMediumStyle),
              ]
            ), 
            error: (error, stackTrace) => Text(error.toString(), style: bodyMediumStyle), 
            loading: () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('', style: bodyMediumStyle),
                const SizedBox(height: 10),
                Text('Correo Electronico', style: subtitleStyle),
                Text('', style: bodyMediumStyle),
                const SizedBox(height: 10),
                Text('Balance', style: subtitleStyle),
                Text('', style: displayMediumStyle),
              ]
            )
          ),

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
                  callback: () => Helper.handleTokenExpired(), 
                  text: 'Cerrar Sesión',
                  style: labelSmallStyle.copyWith(color: Colors.white),
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  borderColor: Colors.white.withValues(alpha: 0.15)
                )
              )
            ]
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0E150F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withAlpha(8), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(45),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Acciones Rápidas", style: subtitleStyle.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                QuickActionTile(
                  icon: Icons.location_on_rounded,
                  title: "Mis Direcciones",
                  subtitle: "Administra tus direcciones de entrega",
                  onTap: () => context.push('/select-address', extra: false),
                ),
                const SizedBox(height: 10),
                QuickActionTile(
                  icon: Icons.lock_rounded,
                  title: "Cambiar Contraseña",
                  subtitle: "Actualiza tu contraseña de forma segura",
                  onTap: () {}
                )
              ]
            )
          ),

          const SizedBox(height: 20),

          Text('Mis Rifas', style: subtitleStyle),

          const SizedBox(height: 10),
          SizedBox(
            height: (screenHeight * 0.125) + 32,
            child: ListView.separated(
              shrinkWrap: true,
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