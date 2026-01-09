import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/domain/entities/address.dart';
import 'package:klicum/domain/entities/country.dart';
import 'package:klicum/presentation/providers/address_provider.dart';
import 'package:klicum/presentation/providers/repositories/address_repository_provider.dart';
import 'package:klicum/presentation/widgets/address/countries_sheet.dart';

import '../../widgets/widgets.dart';

class CreateAddressScreen extends ConsumerStatefulWidget {
  static const name = '/create-address';

  const CreateAddressScreen({super.key});

  @override
  ConsumerState<CreateAddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<CreateAddressScreen> {
  final directionController = TextEditingController();
  final numberController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();

  Country? countrySelected;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void dispose() {
    directionController.dispose();
    numberController.dispose();
    countryController.dispose();
    cityController.dispose();
    zipController.dispose();
    super.dispose();
  }

  SnackBar getSnackbar(Object error, Color color) => Helper.getSnackbar(
    color: color,
    isWarning: Helper.isNetworkError(error),
    text: Helper.isNetworkError(error) ? 'Sin conexion a internet' : Helper.normalizeError(error),
    duration: Helper.isNetworkError(error) ? const Duration(days: 1) : null,
  );      

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final colors = Theme.of(context).colorScheme;

    final displaySmallStyle = Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white);

    final labelLargeStyle = Theme.of(context).textTheme.labelLarge?.copyWith() ?? const TextStyle();

    return Scaffold(
      extendBody: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            const FancyBackground(),

            Positioned(
              top: screenHeight * 0.05,
              child: SizedBox(
                width: screenWidth,
                child: Center(child: MyTitle()),
              ),
            ),

            Positioned(
              top: screenHeight * 0.125,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              bottom: 0,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Añadir Dirección', style: displaySmallStyle),
                  
                      const SizedBox(height: 40),
                  
                      InputField(
                        autoValidateMode: _autoValidate, 
                        labelText: 'Dirección',
                        controller: directionController,
                        validator: (value) {
                          final text = value ?? '';
                          if (text.isEmpty) return 'Este campo es obligatorio';
                          return null;
                        },
                      ),
                        
                      const SizedBox(height: 20),
                        
                      InputField(
                        autoValidateMode: _autoValidate, 
                        labelText: 'Número',
                        controller: numberController,
                        validator: (value) {
                          final text = value ?? '';
                          if (text.isEmpty) return 'Este campo es obligatorio';
                          return null;
                        },
                      ),
                  
                      const SizedBox(height: 20),
                  
                      InputField(
                        readOnly: true,
                        autoValidateMode: _autoValidate, 
                        labelText: 'País',
                        controller: countryController,
                        validator: (value) {
                          final text = value ?? '';
                          if (text.isEmpty) return 'Este campo es obligatorio';
                          return null;
                        },
                        callback: () async {
                          countrySelected = await showModalBottomSheet<Country?>(
                            context: context,
                            isScrollControlled: true,
                            useRootNavigator: true,
                            backgroundColor: AppStyle.backgroundColor,
                            builder: (context) => CountriesSheet()
                          );
                          if (countrySelected == null) return;
                          countryController.text = countrySelected!.name;
                        }
                      ),
                  
                      const SizedBox(height: 20),
                        
                      InputField(
                        autoValidateMode: _autoValidate, 
                        labelText: 'Ciudad',
                        controller: cityController,
                        validator: (value) {
                          final text = value ?? '';
                          if (text.isEmpty) return 'Este campo es obligatorio';
                          return null;
                        }
                      ),
                          
                      const SizedBox(height: 20),
                          
                      InputField(
                        autoValidateMode: _autoValidate, 
                        labelText: 'Código Postal',
                        controller: zipController,
                        validator: (value) {
                          final text = value ?? '';
                          if (text.isEmpty) return 'Este campo es obligatorio';
                          if (text.length < 2) return 'Mínimo 2 caracteres';
                          return null;
                        }
                      ),
                  
                      const SizedBox(height: 40),
                  
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.05,
                        child: Button(
                          callback: () async {
                            try {
                              FocusScope.of(context).unfocus();
                              setState(() => _autoValidate = true);
                              if (!_formKey.currentState!.validate()) return;
                              final id = await ref.read(addressRepositoryProvider).saveAddress(
                                zipCode: zipController.text.trim(), 
                                streetNumber: numberController.text.trim(), 
                                streetName: directionController.text, 
                                city: cityController.text.trim(), 
                                country: countrySelected!.id
                              );
                                
                              if (!mounted) return;
                      
                              final address = Address(
                                id: id, 
                                zipCode: zipController.text.trim(), 
                                streetNumber: numberController.text.trim(), 
                                streetName: directionController.text, 
                                country: countrySelected!.name, 
                                city: cityController.text.trim()
                              );

                              ref.read(addressProvider.notifier).addAddress(address);
                              // ignore: use_build_context_synchronously
                              context.pop();
                            } catch(error) {
                              if (!mounted) return;
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
                                Helper.getSnackbar(
                                  text: Helper.normalizeError(error), 
                                  isWarning: Helper.isNetworkError(error),
                                  color: Helper.isNetworkError(error) ? colors.tertiary : colors.error,
                                  style: labelLargeStyle.copyWith(color: Colors.white),
                                  duration: Helper.isNetworkError(error) ? const Duration(days: 1) : const Duration(seconds: 3)
                                )
                              );
                            }
                          },
                          style: labelLargeStyle.copyWith(fontWeight: FontWeight.bold),
                          text: 'Guardar'
                        )
                      ),
                  
                      const SizedBox(height: 20)
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