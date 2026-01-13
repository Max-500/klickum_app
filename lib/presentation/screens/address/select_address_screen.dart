// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/domain/entities/address.dart';
import 'package:klicum/presentation/providers/address_provider.dart';
import 'package:klicum/presentation/providers/cart_provider.dart';
import 'package:klicum/presentation/providers/repositories/order_repository_provider.dart';
import 'package:klicum/presentation/widgets/address/address_card.dart';
import '../../widgets/widgets.dart';

class SelectAddressScreen extends ConsumerStatefulWidget {
  final bool isFromCart;

  const SelectAddressScreen({super.key, required this.isFromCart});

  @override
  ConsumerState<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends ConsumerState<SelectAddressScreen> {
  bool isLoading = false;
  Address? addressSelected;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final headLineSmallStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white);
    
    final asyncAddress = ref.watch(addressProvider);
    final cartProducts = ref.watch(myCartProvider);

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const FancyBackground(),

          Positioned(
            top: screenHeight * 0.05,
            child: SizedBox(
              width: screenWidth,
              child: Center(child: MyTitle())
            )
          ),

          Positioned(
            top: screenHeight * 0.125,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Eliga la Dirección de Entrega', style: headLineSmallStyle),
                Expanded(
                  child: asyncAddress.when(
                    data: (address) => RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(addressProvider);
                        await ref.read(addressProvider.future);
                      },
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () => setState(() => addressSelected = address[index]),
                          child: AddressCard(address: address[index], isSelected: addressSelected?.id  == address[index].id)
                        ),
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemCount: address.length
                      ),
                    ), 
                    error: (error, stackTrace) => Text(error.toString()), 
                    loading: () => const CircularProgressIndicator()
                  )
                ),
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.05,
                  child: Button(
                    callback: () => context.push('/create-address'), 
                    text: 'Añadir Dirección'
                  )
                ),
                const SizedBox(height: 10),
                widget.isFromCart ? SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.05,
                  child: Button(
                    callback: () async {
                      if (addressSelected == null || isLoading) return;

                      try {
                        setState(() => isLoading = true);
                        await ref.read(orderRepositoryProvider).createOrder(variants: cartProducts, addressID: addressSelected!.id);
                        if (!mounted) return;
                        ref.read(myCartProvider).clear();
                        context.pop();
                        ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(Helper.getSnackbar(
                          text: 'Compra realizada correctamente',
                          isSuccess: true,
                          isWarning: false,
                          color: colors.primary,
                          duration: const Duration(seconds: 5),
                        ));
                      } catch(error) {
                        debugPrint(error.toString());
                        if (!mounted) return;
                        ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(Helper.getSnackbar(
                          text: 'Error al realizar la compra',
                          isSuccess: false,
                          isWarning: Helper.isNetworkError(error),
                          color: Helper.isNetworkError(error) ? colors.tertiary : colors.error,
                          duration: const Duration(seconds: 5),
                        ));

                      } finally {
                        if(mounted) setState(() => isLoading = false);
                      }
                    }, 
                    text: 'Continuar'
                  )
                ) : SizedBox.shrink(),
                SizedBox(height: MediaQuery.of(context).padding.bottom)
              ]
            )
          )
        ]
      )
    );
  }
}