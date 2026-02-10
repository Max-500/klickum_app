import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/presentation/providers/repositories/auth_repository_provider.dart';
import '../../widgets/widgets.dart';

// ignore: must_be_immutable
class SignInScreen extends ConsumerWidget {
  static const String name = '/sign-in';

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final titleStyle = Theme.of(context).textTheme.titleLarge ?? const TextStyle();
    final label = Theme.of(context).textTheme.labelLarge ?? const TextStyle();

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            const SignFancyBackground(),

            Positioned(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.1,
              child: AutoWelcome(subtitle: '¡Bienvenido!')
            ),

            Positioned(
              top: screenHeight * 0.25,
              child: Container(
                width: screenWidth,
                alignment: Alignment.center,
                child: Text(
                  'Iniciar Sesión', 
                  style: titleStyle.copyWith(
                    color: Colors.white, 
                    fontWeight: FontWeight.w600
                  )
                )
              )
            ),

            Positioned(
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              top: screenHeight * 0.3,
              child: Container(
                constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      autoValidateMode: false, 
                      labelText: 'Usuario '
                    ),
                    const SizedBox(height: 20),
                        
                    InputField(
                      controller: passwordController,
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      autoValidateMode: false, 
                      labelText: 'Contraseña '
                    ),
                    const SizedBox(height: 40),
                
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.05,
                      child: Button(
                        callback: () async {
                          try {
                            FocusScope.of(context).unfocus();
                            await ref.read(authRepositoryProvider).signIn(
                              username: usernameController.text.trim(), 
                              password: passwordController.text.trim()
                            );
                            if (context.mounted) context.go('/');
                          }  catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                              Helper.getSnackbar(
                                text: Helper.normalizeError(e), 
                                isWarning: Helper.isNetworkError(e),
                                color: colors.error,
                                style: label.copyWith(color: Colors.white)
                              )
                            );
                          }
                
                        },
                        text: 'Iniciar Sesión', 
                        style: label.copyWith(fontWeight: FontWeight.bold)
                      )
                    ),
                    
                    const SizedBox(height: 10),
                        
                    ActionText(
                      prefix: '¿No tienes una cuenta?', 
                      action: 'Registrate', 
                      onActionTap: () => context.push('/sign-up')
                    )
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }
}