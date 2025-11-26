import 'package:dartz/dartz.dart';

import 'package:finly_app/core/error/exceptions.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/features/categories/data/datasources/category_icon_remote_data_source.dart';
import 'package:finly_app/features/categories/domain/entities/category_icon.dart';
import 'package:finly_app/features/categories/domain/repositories/category_icon_repository.dart';

/// Implementation of [CategoryIconRepository].
///
/// Maps low-level ImageKit models from the remote data source
/// into domain [CategoryIcon] entities and converts exceptions
/// into [Failure] instances.
class CategoryIconRepositoryImpl implements CategoryIconRepository {
  final CategoryIconRemoteDataSource remoteDataSource;

  CategoryIconRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryIcon>>> getCategoryIcons() async {
    try {
      final models = await remoteDataSource.getCategoryIcons();
      final icons =
          models
              .map(
                (m) => CategoryIcon(
                  id: m.name, // no explicit id from API, use name as stable key
                  name: m.name,
                  thumbnailUrl: m.thumbnail,
                ),
              )
              .toList();
      return Right(icons);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
