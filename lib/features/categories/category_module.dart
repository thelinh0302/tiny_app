import 'package:finly_app/features/categories/presentation/bloc/category_transactions_bloc.dart';
import 'package:finly_app/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:finly_app/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finly_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finly_app/features/transactions/domain/usecases/get_transactions.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/services/imagekit_service.dart';
import 'package:finly_app/features/categories/data/datasources/category_icon_remote_data_source.dart';
import 'package:finly_app/features/categories/data/repositories/category_icon_repository_impl.dart';
import 'package:finly_app/features/categories/domain/repositories/category_icon_repository.dart';
import 'package:finly_app/features/categories/domain/usecases/get_category_icons.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_icons_bloc.dart';
import 'package:finly_app/features/categories/presentation/pages/add_category_page.dart';
import 'package:finly_app/features/categories/presentation/pages/add_expense_page.dart';
import 'package:finly_app/features/categories/presentation/pages/category_transactions_page.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';
import 'package:finly_app/features/categories/presentation/pages/categories_page.dart';
import 'package:finly_app/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:finly_app/features/categories/data/repositories/category_repository_impl.dart';
import 'package:finly_app/features/categories/domain/repositories/category_repository.dart';
import 'package:finly_app/features/categories/domain/usecases/get_categories.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_list_bloc.dart';
import 'package:finly_app/core/network/dio_client.dart';
import 'package:finly_app/features/categories/domain/usecases/create_category.dart';
import 'package:finly_app/features/categories/presentation/bloc/add_category_bloc.dart';

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

    // Repository implementation for icons
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

    // Categories list: remote data source -> repository -> use case -> bloc
    i.addLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(client: Modular.get<DioClient>()),
    );
    i.addLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(remote: i.get<CategoryRemoteDataSource>()),
    );
    i.addLazySingleton<GetCategories>(
      () => GetCategories(i.get<CategoryRepository>()),
    );
    i.add<CategoryListBloc>(
      () => CategoryListBloc(getCategories: i.get<GetCategories>()),
    );

    // Add-category use case + bloc (formz)
    i.addLazySingleton<CreateCategory>(
      () => CreateCategory(i.get<CategoryRepository>()),
    );
    i.add<AddCategoryBloc>(
      () => AddCategoryBloc(createCategory: i.get<CreateCategory>()),
    );

    // Transactions for category: remote -> repo -> usecase -> bloc
    i.addLazySingleton<TransactionRemoteDataSource>(
      () => TransactionRemoteDataSourceImpl(client: Modular.get<DioClient>()),
    );
    i.addLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(
        remote: i.get<TransactionRemoteDataSource>(),
      ),
    );
    i.addLazySingleton<GetTransactions>(
      () => GetTransactions(i.get<TransactionRepository>()),
    );
    i.add<CategoryTransactionsBloc>(
      () => CategoryTransactionsBloc(getTransactions: i.get<GetTransactions>()),
    );
  }

  @override
  void routes(RouteManager r) {
    // /dashboard/category -> categories tab root (under MainShell RouterOutlet)
    r.child('/', child: (context) => const CategoriesPage());

    // /dashboard/category/add -> add category screen
    r.child('/add', child: (context) => const AddCategoryPage());

    // /dashboard/category/add-expense -> add expense screen
    r.child(
      '/add-expense',
      child: (context) {
        final initial = r.args.data;
        return AddExpensePage(initialCategory: initial);
      },
    );

    // /dashboard/category/transactions -> category transaction list
    r.child(
      '/transactions',
      child: (context) {
        final category = r.args.data as CategoryData;
        return CategoryTransactionsPage(category: category);
      },
    );
  }
}
