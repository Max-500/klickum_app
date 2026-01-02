import 'package:klicum/domain/entities/category.dart';
import 'package:klicum/infraestructure/models/category_response.dart';

class CategoryMapper {
  static Category categoryResponseToEntity(CategoryResponse response) => Category(id: response.id, name: response.name);
}