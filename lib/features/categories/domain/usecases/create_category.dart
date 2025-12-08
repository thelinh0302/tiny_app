import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/categories/domain/entities/category.dart';
import 'package:finly_app/features/categories/domain/repositories/category_repository.dart';

class CreateCategory implements UseCase<Category, CreateCategoryParams> {
  final CategoryRepository repository;

  CreateCategory(this.repository);

  @override
  Future<Either<Failure, Category>> call(CreateCategoryParams params) {
    return repository.createCategory(
      name: params.name,
      type: params.type,
      icon: params.icon,
    );
  }
}

class CreateCategoryParams extends Equatable {
  final String name;
  final String type; // 'income' | 'expense'
  final String icon; // url

  const CreateCategoryParams({
    required this.name,
    required this.type,
    required this.icon,
  });

  @override
  List<Object?> get props => [name, type, icon];
}
