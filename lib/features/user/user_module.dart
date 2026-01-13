import 'package:flutter_modular/flutter_modular.dart';
import 'package:finly_app/core/network/dio_client.dart';
import 'package:finly_app/features/analytics/data/datasources/analytics_remote_data_source.dart';
import 'package:finly_app/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:finly_app/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:finly_app/features/analytics/domain/usecases/get_analytics_summary.dart';
import 'package:finly_app/features/analytics/presentation/bloc/analytics_summary_bloc.dart';
import 'data/datasources/user_remote_data_source.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/get_user.dart';
import 'domain/usecases/get_users.dart';
import 'presentation/bloc/user_bloc.dart';
import 'presentation/pages/users_page.dart';

/// User feature module using Flutter Modular
/// Following Dependency Inversion Principle and Modular Architecture
class UserModule extends Module {
  @override
  void binds(Injector i) {
    // BLoC
    i.add<UserBloc>(
      () => UserBloc(getUser: i.get<GetUser>(), getUsers: i.get<GetUsers>()),
    );

    // Analytics summary dependencies for header totals in user pages
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

    // Use Cases
    i.addLazySingleton<GetUser>(() => GetUser(i.get<UserRepository>()));
    i.addLazySingleton<GetUsers>(() => GetUsers(i.get<UserRepository>()));

    // Repository
    i.addLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: i.get<UserRemoteDataSource>()),
    );

    // Data Source
    i.addLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(dioClient: Modular.get()),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const UsersPage());
  }
}
