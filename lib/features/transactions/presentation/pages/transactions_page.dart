import 'package:finly_app/core/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:finly_app/features/transactions/presentation/widgets/transactions_top_section.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/transaction_list.dart';
import 'package:finly_app/features/transactions/presentation/widgets/transaction_list_skeleton.dart';
import 'package:finly_app/core/widgets/error_retry.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/widgets/no_result_widget.dart';
import 'package:finly_app/core/widgets/filter_header.dart';
import 'package:finly_app/core/widgets/filter_bottom_sheet.dart'
    show DateRangeFilter, FilterQuickType;

import 'package:finly_app/features/categories/presentation/bloc/category_transactions_bloc.dart';
import 'package:finly_app/features/transactions/presentation/utils/transaction_mappers.dart';
import 'package:finly_app/core/utils/transaction_filters.dart';

/// Transactions page defined under the Transactions feature.
class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late final CategoryTransactionsBloc _bloc;
  final ScrollController _scrollController = ScrollController();
  String? _typeFilter; // null = all, 'income' or 'expense'

  // Persist last filter selection to prefill bottom sheet
  FilterQuickType? _lastQuick;
  DateTime? _lastFrom;
  DateTime? _lastTo;

  void _onFilterIncome() {
    final next = _typeFilter == 'income' ? null : 'income';
    setState(() {
      _typeFilter = next;
    });
    _bloc.add(
      CategoryTransactionsRequested(
        categoryId: '',
        period: '',
        pageSize: 20,
        type: next,
      ),
    );
  }

  void _onFilterExpense() {
    final next = _typeFilter == 'expense' ? null : 'expense';
    setState(() {
      _typeFilter = next;
    });
    _bloc.add(
      CategoryTransactionsRequested(
        categoryId: '',
        period: '',
        pageSize: 20,
        type: next,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc = Modular.get<CategoryTransactionsBloc>();
    _scrollController.addListener(_onScroll);
    // Fetch the first page. Using empty period and an empty categoryId to fetch all if supported by API.
    // Adjust categoryId accordingly if your API requires a specific value.
    _bloc.add(
      const CategoryTransactionsRequested(
        categoryId: '',
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
        categoryId: '',
        period: result.period,
        pageSize: 20,
        type: _typeFilter,
        dateStart: result.dateStart,
        dateEnd: result.dateEnd,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: MainLayout(
        appBar: MainAppBar(titleKey: 'Transaction', showBackButton: false),
        useIntrinsicTopHeight: true,
        topChild: TransactionsTopSection(
          onFilterIncome: _onFilterIncome,
          onFilterExpense: _onFilterExpense,
          selectedType: _typeFilter,
        ),
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
                      return const TransactionListSkeleton(itemCount: 8);
                    }
                    if (state.status == CategoryTxStatus.failure) {
                      return ErrorRetry(
                        message:
                            state.errorMessage ?? 'Failed to load transactions',
                        onRetry: () {
                          _bloc.add(
                            const CategoryTransactionsRequested(
                              categoryId: '',
                              period: '',
                              pageSize: 20,
                            ),
                          );
                        },
                      );
                    }

                    final List<TransactionItemData> items =
                        state.items.map(mapTransactionToItemData).toList();

                    if (items.isEmpty) {
                      return const NoResultWidget();
                    }

                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: TransactionList(items: items),
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
