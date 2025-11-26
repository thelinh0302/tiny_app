import 'package:dartz/dartz.dart';

import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/features/categories/domain/entities/category_icon.dart';

/// Repository contract for loading category icons.
///
/// Presentation (BLoC) depends on this abstraction, not on
/// concrete services or HTTP/Dio.
abstract class CategoryIconRepository {
  Future<Either<Failure, List<CategoryIcon>>> getCategoryIcons();
}
