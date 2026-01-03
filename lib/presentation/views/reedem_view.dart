import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/presentation/providers/repositories/coupon_repository_provider.dart';
import 'package:klicum/presentation/widgets/widgets.dart';

// ignore: must_be_immutable
class ReedemView extends ConsumerWidget {
  final controller = TextEditingController();
  bool isLoading = false;

  ReedemView({super.key});

  SnackBar getSnackbar(Object error, Color color) => Helper.getSnackbar(
    color: color,
    isWarning: Helper.isNetworkError(error),
    text: Helper.isNetworkError(error) ? 'Sin conexion a internet' : Helper.normalizeError(error),
    duration: Helper.isNetworkError(error) ? const Duration(days: 1) : null,
  );      

  @override
  Widget build(BuildContext context, ref) {
    final screenHeight = MediaQuery.of(context).size.height;

    final displaySmallStyle = Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis);

    final labelLargeStyle = Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.w600) ?? const TextStyle(color: Colors.black, fontWeight: FontWeight.w600);

    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Canjear Código', style: displaySmallStyle),
        SizedBox(height: screenHeight * 0.025),
        Text('Introducir Código', style: subtitleStyle),
        const SizedBox(height: 5),
        InputField(autoValidateMode: false, labelText: '', controller: controller),
        SizedBox(height: screenHeight * 0.05),
        SizedBox(
          width: double.infinity,
          height: screenHeight * 0.05,
          child: Button(
            callback: () async {
              try {
                if (isLoading) return;
                isLoading = true;

                await ref.read(couponRepositoryProvider).useCoupon(coupon: controller.text);
                if (context.mounted) {
                  controller.clear();
                  ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(Helper.getSnackbar(
                    color: colors.primary,
                    isWarning: false,
                    isSuccess: true,
                    text: 'Cupón canjeado correctamente',
                    duration: const Duration(seconds: 3)
                  ));
                }
              } catch(error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(getSnackbar(error, Helper.isNetworkError(error) ? colors.tertiary : colors.error));
              } finally {
                isLoading = false;
              }
            }, 
            text: 'Canjear', 
            style: labelLargeStyle
          )
        )
      ]
    );
  }
}