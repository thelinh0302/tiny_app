import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/categories/domain/entities/category.dart';
import 'package:finly_app/features/categories/domain/repositories/category_repository.dart';

class GetCategories
    implements UseCase<CategoriesPageResult, GetCategoriesParams> {
  final CategoryRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, CategoriesPageResult>> call(
    GetCategoriesParams params,
  ) {
    return repository.getCategories(
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class GetCategoriesParams extends Equatable {
  final int page;
  final int pageSize;

  const GetCategoriesParams({required this.page, required this.pageSize});

  @override
  List<Object?> get props => [page, pageSize];
}
