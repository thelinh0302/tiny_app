import 'package:intl/intl.dart';
import 'package:finly_app/features/transactions/domain/entities/transaction.dart';
import 'package:finly_app/core/widgets/transaction_list.dart';
import 'package:finly_app/core/constants/app_images.dart';

/// Maps a domain TransactionEntity into TransactionItemData for UI rendering.
TransactionItemData mapTransactionToItemData(TransactionEntity e) {
  final bool isIncome = e.type.toLowerCase() == 'income';
  final amountFmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  final String amountStr =
      (isIncome ? '+ ' : '- ') + amountFmt.format(e.amount);
  final String timeStr = DateFormat('HH:mm • dd MMM yyyy').format(e.date);

  // Prefer category.icon if it points to an asset in your bundle; fallback to income/expense icons.
  final String icon =
      (e.category.icon?.isNotEmpty == true)
          ? e.category.icon!
          : (isIncome ? AppImages.income : AppImages.expense);

  return TransactionItemData(
    title: e.name,
    timeAndDate: timeStr,
    category: e.category.name,
    amount: amountStr,
    isIncome: isIncome,
    iconAsset: icon,
  );
}
