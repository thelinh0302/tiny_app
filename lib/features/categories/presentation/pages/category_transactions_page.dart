import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/widgets/app_alert.dart';
import 'package:finly_app/core/widgets/dashboard_totals_overview.dart';
import 'package:finly_app/core/widgets/filter_bottom_sheet.dart'
    show DateRangeFilter, FilterQuickType;
import 'package:finly_app/core/widgets/filter_header.dart';
import 'package:finly_app/core/widgets/main_app_bar.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/utils/transaction_filters.dart';
import 'package:finly_app/features/analytics/presentation/bloc/analytics_summary_bloc.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_transactions_bloc.dart';
import 'package:finly_app/features/categories/presentation/models/category_transaction.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_transactions_list.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_transactions_list_skeleton.dart';
import 'package:finly_app/features/transactions/presentation/bloc/delete_transaction_bloc.dart';

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
  late final AnalyticsSummaryBloc _summaryBloc;

  // Persist last filter selection to prefill bottom sheet
  FilterQuickType? _lastQuick;
  DateTime? _lastFrom;
  DateTime? _lastTo;

  @override
  void initState() {
    super.initState();
    _bloc = Modular.get<CategoryTransactionsBloc>();
    _summaryBloc = Modular.get<AnalyticsSummaryBloc>();
    _scrollController.addListener(_onScroll);
    _bloc.add(
      CategoryTransactionsRequested(
        categoryId: widget.category.id,
        period: '',
        pageSize: 20,
      ),
    );
    _summaryBloc.add(const AnalyticsSummaryRequested());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _bloc.close();
    _summaryBloc.close();
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

  void _onApplyFilter(DateRangeFilter res) {
    final result = buildFilterApplyResult(res);

    // Persist selection into state for bottom sheet defaults
    setState(() {
      _lastQuick = result.lastQuick;
      _lastFrom = result.lastFrom;
      _lastTo = result.lastTo;
    });

    _bloc.add(
      CategoryTransactionsRequested(
        categoryId: widget.category.id,
        period: result.period,
        pageSize: 20,
        dateStart: result.dateStart,
        dateEnd: result.dateEnd,
      ),
    );

    // Compute analytics date range via shared helper and dispatch
    final AnalyticsDateRange ar = buildAnalyticsDateRange(res, result);
    if (mounted) {
      _summaryBloc.add(
        AnalyticsSummaryRequested(
          all: ar.startDate == null || ar.endDate == null,
          startDate: ar.startDate,
          endDate: ar.endDate,
        ),
      );
    }
  }

  Future<void> _onDeleteCategoryTransaction(CategoryTransaction ct) async {
    final bool? ok = await AppAlert.confirmAsync(
      context,
      title: 'transactions.delete.title'.tr(),
      message: 'transactions.delete.confirm'.tr(),
      confirmText: 'common.delete'.tr(),
      cancelText: 'common.cancel'.tr(),
      onConfirm: () async {
        final deleteBloc = Modular.get<DeleteTransactionBloc>();
        deleteBloc.add(DeleteTransactionRequested(ct.id));
        final result = await deleteBloc.stream.firstWhere(
          (s) =>
              s.status == DeleteTxnStatus.success ||
              s.status == DeleteTxnStatus.failure,
        );
        return result.status == DeleteTxnStatus.success;
      },
    );

    if (ok == true) {
      _bloc.add(CategoryTransactionRemoved(ct.id));
      if (mounted) {
        await AppAlert.success(
          context,
          'transactions.delete.success'.tr(),
          title: 'common.success'.tr(),
        );
      }
    } else if (ok == false) {
      if (mounted) {
        await AppAlert.error(
          context,
          'transactions.delete.error'.tr(),
          title: 'common.error'.tr(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _bloc),
        BlocProvider.value(value: _summaryBloc),
      ],
      child: MainLayout(
        appBar: MainAppBar(titleKey: widget.category.title),
        topChild: BlocBuilder<AnalyticsSummaryBloc, AnalyticsSummaryState>(
          builder: (context, state) {
            if (state is AnalyticsSummaryLoadInProgress ||
                state is AnalyticsSummaryInitial) {
              return const DashboardTotalsOverview();
            }
            if (state is AnalyticsSummaryLoadFailure) {
              return const DashboardTotalsOverview();
            }
            if (state is AnalyticsSummaryLoadSuccess) {
              final s = state.summary;
              final balanceText = '\$' + s.balance.toStringAsFixed(2);
              final expenseText = '\$' + s.expenseTotal.toStringAsFixed(2);

              double progress = 0.0;
              final denominator = (s.incomeTotal + s.expenseTotal);
              if (denominator > 0) {
                progress = (s.expenseTotal / denominator).clamp(0, 1);
              }

              return DashboardTotalsOverview(
                totalBalanceTitle: 'Total Balance',
                totalBalanceAmount: balanceText,
                totalExpenseTitle: 'Total Expense',
                totalExpenseAmount: expenseText,
                progress: progress,
                progressAmountText: expenseText,
              );
            }
            return const DashboardTotalsOverview();
          },
        ),
        useIntrinsicTopHeight: true,
        enableContentScroll: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.horizontalMedium,
            vertical: AppSpacing.verticalSmall,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilterHeader(
                title: 'transactions.title'.tr(),
                onApply: _onApplyFilter,
                initialFrom: _lastFrom,
                initialTo: _lastTo,
                initialQuickType: _lastQuick,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<
                  CategoryTransactionsBloc,
                  CategoryTransactionsState
                >(
                  builder: (context, state) {
                    if (state.status == CategoryTxStatus.loading &&
                        state.items.isEmpty) {
                      return const CategoryTransactionsListSkeleton(
                        itemCount: 8,
                      );
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
                                id: e.id,
                                title: e.name,
                                dateTime: e.date,
                                amount: e.amount,
                                isExpense: e.type == 'expense',
                                iconAsset:
                                    e.category.icon ??
                                    widget.category.iconAsset,
                              ),
                            )
                            .toList();

                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: CategoryTransactionsList(
                            transactions: mapped,
                            onDelete: _onDeleteCategoryTransaction,
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
            ],
          ),
        ),
      ),
    );
  }
}
