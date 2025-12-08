import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:finly_app/features/categories/domain/entities/category.dart';
import 'package:finly_app/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remote;

  CategoryRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, CategoriesPageResult>> getCategories({
    required int page,
    required int pageSize,
  }) async {
    try {
      final (
        List<Category> items,
        int total,
        int curPage,
        int curPageSize,
        int totalPages,
      ) = await remote.getCategories(page: page, pageSize: pageSize);

      return Right(
        CategoriesPageResult(
          items: items,
          total: total,
          page: curPage,
          pageSize: curPageSize,
          totalPages: totalPages,
        ),
      );
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> createCategory({
    required String name,
    required String type,
    required String icon,
  }) async {
    try {
      final model = await remote.createCategory(
        name: name,
        type: type,
        icon: icon,
      );
      return Right(model);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
