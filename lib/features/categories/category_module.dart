import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/services/imagekit_service.dart';
import 'package:finly_app/features/categories/data/datasources/category_icon_remote_data_source.dart';
import 'package:finly_app/features/categories/data/repositories/category_icon_repository_impl.dart';
import 'package:finly_app/features/categories/domain/repositories/category_icon_repository.dart';
import 'package:finly_app/features/categories/domain/usecases/get_category_icons.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_icons_bloc.dart';
import 'package:finly_app/features/categories/presentation/pages/add_category_page.dart';
import 'package:finly_app/features/categories/presentation/pages/category_transactions_page.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';
import 'package:finly_app/features/main/presentation/pages/main_shell_page.dart';

/// Category feature module.
///
/// Holds the main post-login dashboard (home) experience.
class CategoryModule extends Module {
  @override
  void binds(Injector i) {
    // Core/ImageKit service
    i.addLazySingleton<ImageKitService>(() => ImageKitService());

    // Data source for category icons (wraps ImageKitService)
    i.addLazySingleton<CategoryIconRemoteDataSource>(
      () => CategoryIconRemoteDataSourceImpl(
        imageKitService: i.get<ImageKitService>(),
      ),
    );

    // Repository implementation
    i.addLazySingleton<CategoryIconRepository>(
      () => CategoryIconRepositoryImpl(
        remoteDataSource: i.get<CategoryIconRemoteDataSource>(),
      ),
    );

    // Use case
    i.addLazySingleton<GetCategoryIcons>(
      () => GetCategoryIcons(i.get<CategoryIconRepository>()),
    );

    // BLoC for loading category icons, depends on use case
    i.add<CategoryIconsBloc>(
      () => CategoryIconsBloc(getCategoryIcons: i.get<GetCategoryIcons>()),
    );
  }

  @override
  void routes(RouteManager r) {
    // /category -> main shell with bottom navigation
    r.child('/', child: (context) => const MainShellPage());

    // /category/add -> add category screen
    r.child('/add', child: (context) => const AddCategoryPage());

    // /category/transactions -> category transaction list
    r.child(
      '/transactions',
      child: (context) {
        final category = r.args.data as CategoryData;
        return CategoryTransactionsPage(category: category);
      },
    );
  }
}
