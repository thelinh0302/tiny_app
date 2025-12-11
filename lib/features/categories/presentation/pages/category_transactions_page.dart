import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/widgets/dashboard_totals_overview.dart';
import 'package:finly_app/core/widgets/main_app_bar.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';
import 'package:finly_app/features/categories/presentation/models/category_transaction.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_transactions_list.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_transactions_bloc.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_transactions_list_skeleton.dart';

/// Transactions screen for a selected Category.
/// Uses MainLayout and the reusable TransactionItem widget.
class CategoryTransactionsPage extends StatefulWidget {
  final CategoryData category;

  const CategoryTransactionsPage({super.key, required this.category});

  @override
  State<CategoryTransactionsPage> createState() =>
      _CategoryTransactionsPageState();
}

class _CategoryTransactionsPageState extends State<CategoryTransactionsPage> {
  final ScrollController _scrollController = ScrollController();
  late final CategoryTransactionsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = Modular.get<CategoryTransactionsBloc>();
    _scrollController.addListener(_onScroll);
    _bloc.add(
      CategoryTransactionsRequested(
        categoryId: widget.category.id,
        period: '',
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
    return BlocProvider.value(
      value: _bloc,
      child: MainLayout(
        appBar: MainAppBar(titleKey: widget.category.title),
        topChild: const DashboardTotalsOverview(
          totalBalanceAmount: '5,200.00',
          totalExpenseAmount: '1,250.00',
          progress: 0.35,
          progressAmountText: '7,783.00',
          subtitleText: '35% of your expenses, looks good.',
        ),
        useIntrinsicTopHeight: true,
        enableContentScroll: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.horizontalMedium,
            vertical: AppSpacing.verticalSmall,
          ),
          child:
              BlocBuilder<CategoryTransactionsBloc, CategoryTransactionsState>(
                builder: (context, state) {
                  if (state.status == CategoryTxStatus.loading &&
                      state.items.isEmpty) {
                    return const CategoryTransactionsListSkeleton(itemCount: 8);
                  }
                  if (state.status == CategoryTxStatus.failure) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? 'Failed to load transactions',
                      ),
                    );
                  }

                  final mapped =
                      state.items
                          .map(
                            (e) => CategoryTransaction(
                              title: e.name,
                              dateTime: e.date,
                              amount: e.amount,
                              isExpense: e.type == 'expense',
                              iconAsset:
                                  e.category.icon ?? widget.category.iconAsset,
                            ),
                          )
                          .toList();

                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: CategoryTransactionsList(
                          transactions: mapped,
                          onAddExpense: () async {
                            final result = await Modular.to.pushNamed(
                              '/dashboard/category/add-expense',
                              arguments: widget.category.id,
                            );
                            if (result == true) {
                              _bloc.add(
                                CategoryTransactionsRequested(
                                  categoryId: widget.category.id,
                                  period: '',
                                  pageSize: 20,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Visibility(
                          visible:
                              state.status == CategoryTxStatus.loadingMore &&
                              !state.hasReachedEnd,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
        ),
      ),
    );
  }
}
