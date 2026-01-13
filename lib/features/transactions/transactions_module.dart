import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/network/dio_client.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_transactions_bloc.dart';
import 'package:finly_app/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:finly_app/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finly_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finly_app/features/transactions/domain/usecases/get_transactions.dart';
import 'package:finly_app/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:finly_app/features/transactions/presentation/bloc/delete_transaction_bloc.dart';
import 'package:finly_app/features/transactions/presentation/pages/transactions_page.dart';
import 'package:finly_app/features/analytics/data/datasources/analytics_remote_data_source.dart';
import 'package:finly_app/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:finly_app/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:finly_app/features/analytics/domain/usecases/get_analytics_summary.dart';
import 'package:finly_app/features/analytics/presentation/bloc/analytics_summary_bloc.dart';

/// Transactions feature module.
/// Exposes '/transactions' root via ModuleRoute in the DashboardModule.
class TransactionsModule extends Module {
  @override
  void binds(Injector i) {
    // Transactions dependencies (duplicated here so this module works standalone)
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
    i.addLazySingleton<DeleteTransaction>(
      () => DeleteTransaction(i.get<TransactionRepository>()),
    );
    i.add<DeleteTransactionBloc>(
      () =>
          DeleteTransactionBloc(deleteTransaction: i.get<DeleteTransaction>()),
    );
    i.add<CategoryTransactionsBloc>(
      () => CategoryTransactionsBloc(getTransactions: i.get<GetTransactions>()),
    );

    // Analytics summary for transactions top section
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
    // /transactions -> TransactionsPage
    r.child('/', child: (context) => const TransactionsPage());
  }
}
