import 'package:klicum/domain/entities/country.dart';

class CountriesData {
  final int totalPages;
  final List<Country> countries;

  CountriesData({required this.totalPages, required this.countries});
}