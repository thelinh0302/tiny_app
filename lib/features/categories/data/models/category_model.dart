import 'package:finly_app/features/categories/domain/entities/category.dart'
    as domain;

class CategoryModel extends domain.Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.type,
    super.iconUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      iconUrl: json['icon'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
