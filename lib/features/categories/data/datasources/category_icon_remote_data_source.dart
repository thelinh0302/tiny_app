import 'package:finly_app/core/models/imagekit_file.dart';
import 'package:finly_app/core/services/imagekit_service.dart';

/// Remote data source contract for category icons.
abstract class CategoryIconRemoteDataSource {
  Future<List<ImageKitFileModel>> getCategoryIcons();
}

/// Implementation using the shared [ImageKitService].
class CategoryIconRemoteDataSourceImpl implements CategoryIconRemoteDataSource {
  final ImageKitService imageKitService;

  CategoryIconRemoteDataSourceImpl({required this.imageKitService});

  @override
  Future<List<ImageKitFileModel>> getCategoryIcons() {
    // Delegate to core service; any errors are surfaced to repository layer.
    return imageKitService.fetchCategoryIcons();
  }
}
