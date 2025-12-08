import 'package:dio/dio.dart';
import 'package:finly_app/core/network/dio_client.dart';
import 'package:finly_app/features/categories/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<
    (
      List<CategoryModel> items,
      int total,
      int page,
      int pageSize,
      int totalPages,
    )
  >
  getCategories({required int page, required int pageSize});

  Future<CategoryModel> createCategory({
    required String name,
    required String type,
    required String icon,
  });
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final DioClient client;

  CategoryRemoteDataSourceImpl({required this.client});

  @override
  Future<
    (
      List<CategoryModel> items,
      int total,
      int page,
      int pageSize,
      int totalPages,
    )
  >
  getCategories({required int page, required int pageSize}) async {
    try {
      final Response res = await client.get(
        '/categories',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final data = res.data as Map<String, dynamic>;
      final items =
          (data['items'] as List<dynamic>)
              .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList();
      final total = (data['total'] as num).toInt();
      final curPage = (data['page'] as num).toInt();
      final curPageSize = (data['pageSize'] as num).toInt();
      final totalPages = (data['totalPages'] as num).toInt();
      return (items, total, curPage, curPageSize, totalPages);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<CategoryModel> createCategory({
    required String name,
    required String type,
    required String icon,
  }) async {
    try {
      final Response res = await client.post(
        '/categories',
        data: {'name': name, 'type': type, 'icon': icon},
      );
      final data = res.data as Map<String, dynamic>;
      return CategoryModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
