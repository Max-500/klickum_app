import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/domain/entities/address.dart';

class AddressCard extends StatelessWidget {
  final Address address;
  final bool isSelected;

  const AddressCard({super.key, required this.address, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSelected ? AppStyle.primaryColor : Colors.white.withAlpha(45), width: 2),
        color: Colors.white.withAlpha(15)
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppStyle.primaryColor : Colors.white.withValues(alpha: 0.45)
            )
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dirección: ${address.streetName}', style: TextStyle(color: Colors.white)),
                Text('Número: ${address.streetNumber}', style: TextStyle(color: Colors.white)),
                Text('Ciudad: ${address.city}', style: TextStyle(color: Colors.white)),
                Text('País: ${address.country}', style: TextStyle(color: Colors.white)),
                Text('Código Postal: ${address.zipCode}', style: TextStyle(color: Colors.white))
              ]
            )
          )
        ]
      )
    );
  }
}