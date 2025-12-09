import 'package:finly_app/features/transactions/domain/entities/transaction.dart'
    as domain;

class TransactionCategoryModel extends domain.TransactionCategory {
  const TransactionCategoryModel({
    required super.id,
    required super.name,
    super.icon,
  });

  factory TransactionCategoryModel.fromJson(Map<String, dynamic> json) {
    return TransactionCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
    );
  }
}

class TransactionModel extends domain.TransactionEntity {
  const TransactionModel({
    required super.id,
    super.userId,
    super.accountId,
    required super.category,
    required super.name,
    required super.amount,
    required super.type,
    super.note,
    required super.date,
    super.attachmentUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final categoryJson = json['category'] as Map<String, dynamic>;
    return TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      accountId: json['accountId'] as String?,
      category: TransactionCategoryModel.fromJson(categoryJson),
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      note: json['note'] as String?,
      date: DateTime.parse(json['date'] as String),
      attachmentUrl: json['attachmentUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class TransactionsPageResultModel extends domain.TransactionsPageResult {
  const TransactionsPageResultModel({
    required super.items,
    required super.total,
    required super.page,
    required super.pageSize,
    required super.totalPages,
  });

  factory TransactionsPageResultModel.fromJson(Map<String, dynamic> json) {
    final items =
        (json['items'] as List)
            .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
            .toList();
    return TransactionsPageResultModel(
      items: items,
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}
