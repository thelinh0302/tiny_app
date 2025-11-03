import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/language_selector.dart';
import '../bloc/user_bloc.dart';
import '../widgets/user_list_widget.dart';

/// Users page - Presentation layer
/// Following Single Responsibility Principle
class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Modular.get<UserBloc>()..add(const GetUsersEvent()),
      child: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: Text('users.title'.tr()),
                actions: const [LanguageSelector(), SizedBox(width: 8)],
              ),
              body: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UsersLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text('users.loading'.tr()),
                        ],
                      ),
                    );
                  } else if (state is UsersLoaded) {
                    return UserListWidget(users: state.users);
                  } else if (state is UsersError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.errorColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'users.error'.tr(
                              namedArgs: {'message': state.message},
                            ),
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<UserBloc>(
                                context,
                              ).add(const GetUsersEvent());
                            },
                            child: Text('users.retry'.tr()),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(child: Text('app.welcome'.tr()));
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  BlocProvider.of<UserBloc>(context).add(const GetUsersEvent());
                },
                tooltip: 'users.refresh'.tr(),
                child: const Icon(Icons.refresh),
              ),
            ),
      ),
    );
  }
}
