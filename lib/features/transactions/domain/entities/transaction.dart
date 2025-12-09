import 'package:equatable/equatable.dart';

class TransactionCategory extends Equatable {
  final String id;
  final String name;
  final String? icon;

  const TransactionCategory({required this.id, required this.name, this.icon});

  @override
  List<Object?> get props => [id, name, icon];
}

class TransactionEntity extends Equatable {
  final String id;
  final String? userId;
  final String? accountId;
  final TransactionCategory category;
  final String name;
  final double amount;
  final String type; // 'income' | 'expense'
  final String? note;
  final DateTime date;
  final String? attachmentUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionEntity({
    required this.id,
    this.userId,
    this.accountId,
    required this.category,
    required this.name,
    required this.amount,
    required this.type,
    this.note,
    required this.date,
    this.attachmentUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    accountId,
    category,
    name,
    amount,
    type,
    note,
    date,
    attachmentUrl,
    createdAt,
    updatedAt,
  ];
}

class TransactionsPageResult extends Equatable {
  final List<TransactionEntity> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  const TransactionsPageResult({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [items, total, page, pageSize, totalPages];
}
