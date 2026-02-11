// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/presentation/providers/order_provider.dart';
import 'package:klicum/presentation/providers/raffles_provider.dart';
import 'package:klicum/presentation/providers/repositories/auth_repository_provider.dart';
import 'package:klicum/presentation/providers/repositories/recharge_repository_provider.dart';
import 'package:klicum/presentation/providers/user_provider.dart';
import 'package:klicum/presentation/widgets/widgets.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final scrollControllerRaffles = ScrollController();
  final scrollControllerOrders = ScrollController();
  final amountController = TextEditingController();

  final currentController = TextEditingController();
  final nextController = TextEditingController();
  final confirmController = TextEditingController();


  @override
  void initState() {
    super.initState();
    scrollControllerRaffles.addListener(() {
      if (!mounted) return;

      final max = scrollControllerRaffles.position.maxScrollExtent;
      final offset = scrollControllerRaffles.offset;

      if (offset >= max - 300) ref.read(orderProvider.notifier).loadMoreOrders();
    });

    scrollControllerOrders.addListener(() {
      if (!mounted) return;

      final max = scrollControllerOrders.position.maxScrollExtent;
      final offset = scrollControllerOrders.offset;

      if (offset >= max - 300) ref.read(myRafflesProvider.notifier).loadMoreRaffles();
    });
  }

  @override
  void dispose() {
    scrollControllerRaffles.dispose();
    scrollControllerOrders.dispose();
    amountController.dispose();
    currentController.dispose();
    nextController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<({String current, String next})?> openChangePasswordSheet({
    required BuildContext context,
    required double screenWidth,
    required TextStyle buttonTextStyle,
  }) async {
    final formKey = GlobalKey<FormState>();
    AutovalidateMode autoValidate = AutovalidateMode.disabled;

    final result = await showModalBottomSheet<({String current, String next})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppStyle.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return SafeArea(
              top: false,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  top: 12,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
                ),
                child: Form(
                  key: formKey,
                  autovalidateMode: autoValidate,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white24,
                          ),
                        ),
                      ),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cambiar contraseña',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Contraseña actual
                      InputField(
                        controller: currentController,
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: 'Contraseña actual',
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty) return 'Ingresa tu contraseña actual';
                          return null;
                        },
                        autoValidateMode: autoValidate == AutovalidateMode.always,
                      ),

                      const SizedBox(height: 14),

                      // Nueva contraseña (tu validación)
                      InputField(
                        controller: nextController,
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: 'Nueva contraseña',
                        validator: (value) {
                          final text = value?.trim() ?? '';

                          if (text.length < 8) return 'Debe tener al menos 8 caracteres';
                          if (!RegExp(r'[A-Z]').hasMatch(text)) return 'Debe incluir al menos una letra mayúscula';
                          if (!RegExp(r'[a-z]').hasMatch(text)) return 'Debe incluir al menos una letra minúscula';
                          if (!RegExp(r'\d').hasMatch(text)) return 'Debe incluir al menos un número';
                          if (!RegExp(r'[!@#\$&*~_\-]').hasMatch(text)) {
                            return 'Debe incluir al menos un símbolo (!@#\$&*~_- )';
                          }
                          return null;
                        },
                        autoValidateMode: autoValidate == AutovalidateMode.always,
                      ),

                      const SizedBox(height: 14),

                      // Confirmar nueva
                      InputField(
                        controller: confirmController,
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: 'Confirmar nueva contraseña',
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty) return 'Confirma tu nueva contraseña';
                          if (text != nextController.text.trim()) return 'No coincide con la nueva contraseña';
                          return null;
                        },
                        autoValidateMode: autoValidate == AutovalidateMode.always,
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        child: Button(
                          text: 'Guardar cambios',
                          style: buttonTextStyle.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                          callback: () {
                            final ok = formKey.currentState?.validate() ?? false;
                            if (!ok) {
                              setState(() => autoValidate = AutovalidateMode.always);
                              return;
                            }

                            Navigator.pop(ctx, (
                              current: currentController.text.trim(),
                              next: nextController.text.trim(),
                            ));
                          }
                        )
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: Button(
                          callback: () => Navigator.pop(ctx),
                          text: 'Cancelar',
                          style: buttonTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          borderColor: Colors.white.withValues(alpha: 0.15)
                        )
                      ),

                      const SizedBox(height: 8),
                    ]
                  )
                )
              )
            );
          }
        );
      },
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final colors = Theme.of(context).colorScheme;

    final displayMediumStyle = Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
    final displaySmallStyle = Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);    
    final bodyMediumStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle();
    
    final asyncMe = ref.watch(meProvider);
    final asyncMyRaffles = ref.watch(myRafflesProvider);
    final asyncOrders = ref.watch(orderProvider);

    return RefreshIndicator(
      onRefresh: () async {
        try {
          ref.invalidate(meProvider);
          ref.invalidate(myRafflesProvider);
          ref.invalidate(orderProvider);
          await ref.read(meProvider.future);
          if (mounted) await ref.read(myRafflesProvider.future);
          if (mounted) await ref.read(orderProvider.future);
        } catch (e) {
          //TODO
        }
      },
      child: CustomScrollView(
        controller: scrollControllerOrders,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
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
                      Text('${me.balance.toStringAsFixed(2)}€', style: displayMediumStyle)
                    ]
                  ),
                  error: (error, stackTrace) => Text(Helper.normalizeError(error), style: bodyMediumStyle),
                  loading: () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('', style: bodyMediumStyle),
                      const SizedBox(height: 10),
                      Text('Correo Electronico', style: subtitleStyle),
                      Text('', style: bodyMediumStyle),
                      const SizedBox(height: 10),
                      Text('Balance', style: subtitleStyle),
                      Text('', style: displayMediumStyle)
                    ]
                  )
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
                        offset: const Offset(0, 10)
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Acciones Rápidas", style: subtitleStyle.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      QuickActionTile(
                        icon: Icons.attach_money,
                        title: "Recargar Saldo",
                        subtitle: "Agrega dinero a tu cuenta en segundos",
                        onTap: () async {
                          try {
                            final amount = await showModalBottomSheet<int?>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: AppStyle.backgroundColor,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
                              builder: (ctx) => SafeArea(
                                top: false,
                                child: AnimatedPadding(
                                  duration: const Duration(milliseconds: 220),
                                  curve: Curves.easeOut,
                                  padding: EdgeInsets.only(
                                    left: screenWidth * 0.05,
                                    right: screenWidth * 0.05,
                                    top: 12,
                                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 44,
                                          height: 4,
                                          margin: const EdgeInsets.only(bottom: 14),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.white24
                                          )
                                        )
                                      ),

                                      InputField(
                                        textInputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        autoValidateMode: false,
                                        labelText: 'Ingresa la cantidad a recargar',
                                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                                        controller: amountController
                                      ),

                                      const SizedBox(height: 20),

                                      SizedBox(
                                        width: double.infinity,
                                        child: Button(
                                          callback: () {
                                            final amount = amountController.text.isNotEmpty ? int.parse(amountController.text) : null;
                                            amountController.clear();
                                            context.pop(amount);
                                          },
                                          text: 'Aceptar',
                                          style: bodyMediumStyle.copyWith(color: Colors.black)
                                        )
                                      ),

                                      const SizedBox(height: 10)
                                    ]
                                  )
                                )
                              )
                            );

                            if (amount == null) return;

                            final intent = await ref.read(rechargeRepositoryProvider).createIntent(amount: amount);
                            if (!mounted) return;
                            await Stripe.instance.initPaymentSheet(
                              paymentSheetParameters: SetupPaymentSheetParameters(
                                style: ThemeMode.system,
                                paymentIntentClientSecret: intent.clientSecret,
                                merchantDisplayName: 'Klickum',
                                appearance: const PaymentSheetAppearance(
                                  colors: PaymentSheetAppearanceColors(
                                    background: Color(0xFF0F1115),          // fondo principal
                                    componentBackground: Color(0xFF1A1F2A), // cards/botones de métodos
                                    componentBorder: Color(0xFF2A3342),
                                    componentDivider: Color(0xFF2A3342),
                                    primary: AppStyle.primaryColor,             // acentos
                                    placeholderText: Color(0xFF8B94A5),
                                    primaryText: Colors.black
                                  ),
                                  primaryButton: PaymentSheetPrimaryButtonAppearance(
                                    colors: PaymentSheetPrimaryButtonTheme(
                                      dark: PaymentSheetPrimaryButtonThemeColors(
                                        background: AppStyle.primaryColor, //Color(0xFF00D26A),
                                        text: Colors.black //Color(0xFF000000),
                                      ),
                                      light: PaymentSheetPrimaryButtonThemeColors(
                                        background: AppStyle.primaryColor,
                                        text: Colors.black
                                      )
                                    )
                                  )
                                )
                              )
                            );
                            if (!mounted) return;
                            await Stripe.instance.presentPaymentSheet();
                          } catch (error) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                              Helper.getSnackbar(
                                color: Helper.isNetworkError(error) ? colors.tertiary : colors.error,
                                isWarning: Helper.isNetworkError(error),
                                text: Helper.isNetworkError(error) ? 'Sin conexion a internet' : error is StripeException ? Helper.stripeMsgFrom(error) : Helper.normalizeError(error),
                                duration: Helper.isNetworkError(error) ? const Duration(days: 1) : const Duration(seconds: 5)
                              )
                            );
                          }
                        }
                      ),
                      const SizedBox(height: 10),
                      QuickActionTile(
                        icon: Icons.location_on_rounded,
                        title: "Mis Direcciones",
                        subtitle: "Administra tus direcciones de entrega",
                        onTap: () => context.push('/select-address', extra: false)
                      ),
                      const SizedBox(height: 10),
                      QuickActionTile(
                        icon: Icons.lock_rounded,
                        title: "Cambiar Contraseña",
                        subtitle: "Actualiza tu contraseña de forma segura",
                        onTap: () async {
                          try {
                            final data = await openChangePasswordSheet(
                              context: context,
                              screenWidth: screenWidth,
                              buttonTextStyle: bodyMediumStyle,
                            );

                            if (data == null) return;

                            await ref.read(authRepositoryProvider).changePassword(
                              currentPassword: data.current,
                              newPassword: data.next
                            );

                            if (!mounted) return;

                            ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                              Helper.getSnackbar(
                                color: colors.primary,
                                isSuccess: true,
                                isWarning: false,
                                text: 'Contraseña Actualizada Correctamente',
                                duration: const Duration(seconds: 5)
                              )
                            );
                          } catch (error) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                              Helper.getSnackbar(
                                color: Helper.isNetworkError(error) ? colors.tertiary : colors.error,
                                isWarning: Helper.isNetworkError(error),
                                text: Helper.isNetworkError(error) ? 'Sin conexion a internet' : 'Error al actualizar la contraseña',
                                duration: const Duration(seconds: 5)
                              )
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      QuickActionTile(
                        icon: Icons.exit_to_app,
                        title: "Cerrar Sesión",
                        subtitle: "Salir de tu cuenta",
                        onTap: () => Helper.handleTokenExpired()
                      )
                    ]
                  )
                ),
      
                const SizedBox(height: 20),
      
                Text('Mis Rifas', style: subtitleStyle),
                const SizedBox(height: 10)
              ]
            )
          ),
      
          SliverToBoxAdapter(
            child: SizedBox(
              height: (screenHeight * 0.2) + 20,
              child: asyncMyRaffles.when(
                data: (myRaffles) => myRaffles.isEmpty ? NoData(msg: 'Aun no participas en ninguna rifa') : ListView.separated(
                  controller: scrollControllerRaffles,
                  scrollDirection: Axis.horizontal,
                  itemCount: myRaffles.length,
                  separatorBuilder: (_, _) => SizedBox(width: screenWidth * 0.05),
                  itemBuilder: (_, index) => MyRaffleCard(myRaffle: myRaffles[index])
                ),
                error: (error, stackTrace) => NoData(msg: Helper.normalizeError(error)),
                loading: () => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  separatorBuilder: (_, _) => SizedBox(width: screenWidth * 0.05),
                  itemBuilder: (_, _) => MyRaffleCardSkeleton()
                )
              )
            )
          ),
      
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text('Mis Pedidos', style: subtitleStyle),
                const SizedBox(height: 10),
              ]
            )
          ),
      
          asyncOrders.when(
            data: (orders) => orders.isEmpty ? SliverToBoxAdapter(child: NoData(msg: 'Aun no has comprado nada')) : SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => MyOrderCard(order: orders[index]),
                childCount: orders.length,
              )
            ), 
            error: (error, stackTrace) => SliverToBoxAdapter(child: Text(Helper.normalizeError(error))), 
            loading: () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, _) => MyOrderCardSkeleton(),
                childCount: 10
              )
            )
          ),
      
          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom))
        ]
      ),
    );
  }
}