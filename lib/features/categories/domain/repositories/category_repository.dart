import 'package:dartz/dartz.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/features/categories/domain/entities/category.dart';

class CategoriesPageResult {
  final List<Category> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  const CategoriesPageResult({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });
}

abstract class CategoryRepository {
  Future<Either<Failure, CategoriesPageResult>> getCategories({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, Category>> createCategory({
    required String name,
    required String type,
    required String icon,
  });
}
