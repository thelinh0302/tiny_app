import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/widgets/filter_segmented_control.dart';
import 'package:finly_app/features/dashboard/presentation/widgets/savings_goals_card.dart';
import 'package:finly_app/core/widgets/transaction_list.dart';
import 'package:finly_app/core/widgets/error_retry.dart';
import 'package:finly_app/core/widgets/no_result_widget.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_transactions_bloc.dart';
import 'package:finly_app/features/transactions/presentation/utils/transaction_mappers.dart';

/// Center section of the home dashboard.
/// Shows the custom "Savings on Goals" widget card and time filter.
class HomeOverviewSection extends StatefulWidget {
  const HomeOverviewSection({super.key});

  @override
  State<HomeOverviewSection> createState() => _HomeOverviewSectionState();
}

class _HomeOverviewSectionState extends State<HomeOverviewSection> {
  String _selectedFilter = 'Daily';
  late final CategoryTransactionsBloc _bloc;
  final ScrollController _scrollController = ScrollController();

  String _toPeriod(String filter) {
    switch (filter) {
      case 'Daily':
        return 'daily';
      case 'Weekly':
        return 'week';
      case 'Monthly':
        return 'month';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc = Modular.get<CategoryTransactionsBloc>();
    _scrollController.addListener(_onScroll);
    _bloc.add(
      CategoryTransactionsRequested(
        categoryId: '',
        period: _toPeriod(_selectedFilter),
        pageSize: 20,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    if (offset >= max - 100) {
      _bloc.add(CategoryTransactionsLoadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.horizontalSmall),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SavingsGoalsCard(),
                AppSpacing.verticalSpaceMedium,
                Center(
                  // Time-range filter: Daily / Weekly / Monthly
                  child: FilterSegmentedControl<String>(
                    options: const ['Daily', 'Weekly', 'Monthly'],
                    value: _selectedFilter,
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value;
                      });
                      _bloc.add(
                        CategoryTransactionsRequested(
                          categoryId: '',
                          period: _toPeriod(value),
                          pageSize: 20,
                        ),
                      );
                    },
                  ),
                ),
                AppSpacing.verticalSpaceLarge,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<
              CategoryTransactionsBloc,
              CategoryTransactionsState
            >(
              bloc: _bloc,
              builder: (context, state) {
                if (state.status == CategoryTxStatus.loading &&
                    state.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == CategoryTxStatus.failure) {
                  return ErrorRetry(
                    message:
                        state.errorMessage ?? 'Failed to load transactions',
                    onRetry: () {
                      _bloc.add(
                        CategoryTransactionsRequested(
                          categoryId: '',
                          period: _toPeriod(_selectedFilter),
                          pageSize: 20,
                        ),
                      );
                    },
                  );
                }

                final items =
                    state.items.map(mapTransactionToItemData).toList();

                if (items.isEmpty) {
                  return const NoResultWidget();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TransactionList(items: items),
                    AppSpacing.verticalSpaceSmall,
                    if (state.status == CategoryTxStatus.loadingMore &&
                        !state.hasReachedEnd)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
