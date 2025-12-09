import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/config/style/app_style.dart';
import '../../widgets/widgets.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  static const String name = '/sign-up';

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final titleStyle = Theme.of(context).textTheme.titleLarge ?? const TextStyle();
    final label = Theme.of(context).textTheme.labelLarge ?? const TextStyle();
    
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            const SignFancyBackground(),
        
            Positioned(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.1,
              child: AutoWelcome(subtitle: 'Únete a Nosotros')
            ),
        
            Positioned(
              top: screenHeight * 0.25,
              child: Container(
                width: screenWidth,
                alignment: Alignment.center,
                child: Text(
                  'Crear Cuenta', 
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InputField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          final text = value?.trim() ?? '';

                          if (text.isEmpty) return 'Este campo es obligatorio';

                          if (text.length > 15) return 'Maximo 15 caracteres';

                          if (double.tryParse(text) != null) return 'Este campo no se puede componer por puros números';

                          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(text)) return 'Solo se permiten letras, números y _';

                          return null;
                        },
                        autoValidateMode: _autoValidate, 
                        labelText: 'Usuario '
                      ),
                      const SizedBox(height: 20),
        
                      InputField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final text = value?.trim() ?? '';

                          if (text.isEmpty) return 'Este campo es obligatorio';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(text)) return 'Ingresa un correo válido';

                          return null;
                        },
                        autoValidateMode: true, 
                        labelText: 'Correo Electronico '
                      ),
                      const SizedBox(height: 20),

                      InputField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          final text = value?.trim() ?? '';

                          if (text.isEmpty) return 'Este campo es obligatorio';
                          if (!RegExp(r'^\+?\d+$').hasMatch(text)) return 'Solo se permiten números';
                          if (text.length < 10 || text.length > 15) return 'Ingresa un teléfono válido';

                          return null;
                        },
                        autoValidateMode: _autoValidate, 
                        labelText: 'Telefono '
                      ),
                      const SizedBox(height: 20),

                      InputField(
                        controller: passwordController,
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          final text = value?.trim() ?? '';

                          if (text.isEmpty) return 'Este campo es obligatorio';
                          if (!RegExp(r'^\+?\d+$').hasMatch(text)) return 'Solo se permiten números';
                          if (text.length < 10 || text.length > 15) return 'Ingresa un teléfono válido';
                          
                          return null;
                        },
                        autoValidateMode: _autoValidate, 
                        labelText: 'Contraseña '
                      ),
                      const SizedBox(height: 20),

                      InputField(
                        controller: confirmPasswordController,
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (passwordController.text != confirmPasswordController.text) return 'Las contaseñas no coinciden';
                          return null;
                        },
                        autoValidateMode: _autoValidate, 
                        labelText: 'Confirmar Contraseña '
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.05,
                        child: ElevatedButton(
                          onPressed: () {
                            try {
                              FocusScope.of(context).unfocus();
                              _autoValidate = true;
                              if (_formKey.currentState!.validate()) {
                              }
                            }  catch (e) {
                              // TODO
                            }

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyle.primaryColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1)
                            )
                          ),
                          child: Text(
                            'Registrarse', 
                            style: label.copyWith(
                              fontWeight: FontWeight.bold
                            )
                          )
                        ),
                      ),
        
                      const SizedBox(height: 10,),
        
                      ActionText(
                        prefix: '¿Ya tienes una cuenta?', 
                        action: 'Ingresa', 
                        onActionTap: () => context.pop()
                      )
                    ]
                  )
                )
              )
            )
        
          ]
        )
      )
    );
  }
}