import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/network/dio_client.dart';
import 'package:finly_app/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:finly_app/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finly_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finly_app/features/transactions/domain/usecases/get_transactions.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_transactions_bloc.dart';

import 'package:finly_app/features/main/presentation/pages/main_shell_page.dart';
import 'package:finly_app/features/dashboard/presentation/pages/home_page.dart';
import 'package:finly_app/features/user/presentation/pages/analytics_page.dart';
import 'package:finly_app/features/transactions/transactions_module.dart';
import 'package:finly_app/features/user/presentation/pages/profile_page.dart';
import 'package:finly_app/features/user/presentation/pages/settings_page.dart';
import 'package:finly_app/features/categories/category_module.dart';
import 'package:finly_app/features/analytics/data/datasources/analytics_remote_data_source.dart';
import 'package:finly_app/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:finly_app/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:finly_app/features/analytics/domain/usecases/get_analytics_summary.dart';
import 'package:finly_app/features/analytics/presentation/bloc/analytics_summary_bloc.dart';

/// Dashboard feature module.
///
/// Holds the main post-login dashboard (home) experience.
class DashboardModule extends Module {
  @override
  void binds(Injector i) {
    // Provide transactions dependencies for Home page usage
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

    // Analytics summary for home header
    i.addLazySingleton<AnalyticsRemoteDataSource>(
      () => AnalyticsRemoteDataSourceImpl(client: Modular.get<DioClient>()),
    );
    i.addLazySingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(remote: i.get<AnalyticsRemoteDataSource>()),
    );
    i.addLazySingleton<GetAnalyticsSummary>(
      () => GetAnalyticsSummary(i.get<AnalyticsRepository>()),
    );
    i.add<AnalyticsSummaryBloc>(
      () => AnalyticsSummaryBloc(
        getAnalyticsSummary: i.get<GetAnalyticsSummary>(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    // /dashboard -> main shell with bottom navigation and nested routes
    r.child(
      '/',
      child: (context) => const MainShellPage(),
      children: [
        ChildRoute('/home', child: (context) => const HomePage()),
        ChildRoute('/analytics', child: (context) => const AnalyticsPage()),
        ModuleRoute('/transactions', module: TransactionsModule()),
        ModuleRoute('/category', module: CategoryModule()),
        ChildRoute('/profile', child: (context) => const ProfilePage()),
        ChildRoute('/settings', child: (context) => const SettingsPage()),
      ],
    );
  }
}
