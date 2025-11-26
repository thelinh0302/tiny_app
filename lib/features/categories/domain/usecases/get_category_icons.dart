import 'package:dartz/dartz.dart';

import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/categories/domain/entities/category_icon.dart';
import 'package:finly_app/features/categories/domain/repositories/category_icon_repository.dart';

/// Use case for getting all available category icons.
class GetCategoryIcons implements UseCase<List<CategoryIcon>, NoParams> {
  final CategoryIconRepository repository;

  GetCategoryIcons(this.repository);

  @override
  Future<Either<Failure, List<CategoryIcon>>> call(NoParams params) {
    return repository.getCategoryIcons();
  }
}
