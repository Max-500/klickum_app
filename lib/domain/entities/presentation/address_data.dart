import 'package:klicum/domain/entities/address.dart';

class AddressData {
  final int totalPages;
  final List<Address> address;

  AddressData({required this.totalPages, required this.address});
}