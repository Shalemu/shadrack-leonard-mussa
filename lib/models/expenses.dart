class Expense {
  final int id;
  final String name;
  final DateTime? date; // Nullable date
  final int amount;
  final String? description;
  final int shop;
  final int expenseCategory;
  final int adminId;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int syncStatus; // Track sync status

  Expense({
    required this.id,
    required this.name,
    this.date,
    required this.amount,
    this.description,
    required this.shop,
    required this.expenseCategory,
    required this.adminId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 0,
  });

  // Copy method to create a new instance with a different syncStatus
  Expense copyWith({int? syncStatus}) {
    return Expense(
      id: id,
      name: name,
      date: date,
      amount: amount,
      description: description,
      shop: shop,
      expenseCategory: expenseCategory,
      adminId: adminId,
      deletedAt: deletedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus ?? this.syncStatus, // Use new syncStatus if provided
    );
  }

  // Convert an Expense into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date?.toIso8601String(),
      'amount': amount,
      'description': description,
      'shop': shop,
      'expense_category': expenseCategory,
      'admin_id': adminId,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sync_status': syncStatus,
    };
  }

  // Extract an Expense from a Map.
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: int.tryParse(map['id'].toString()) ?? 0,
      name: map['name'] ?? 'No Name',
      date: map['date'] != null ? DateTime.tryParse(map['date']) : null,
      amount: int.tryParse(map['amount'].toString()) ?? 0,
      description: map['description'],
      shop: int.tryParse(map['shop'].toString()) ?? 0,
      expenseCategory: int.tryParse(map['expense_category'].toString()) ?? 0,
      adminId: int.tryParse(map['admin_id'].toString()) ?? 0,
      deletedAt: map['deleted_at'] != null ? DateTime.tryParse(map['deleted_at']) : null,
      createdAt: DateTime.tryParse(map['created_at'] ?? DateTime.now().toIso8601String()) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? DateTime.now().toIso8601String()) ?? DateTime.now(),
      syncStatus: int.tryParse(map['sync_status'].toString()) ?? 0,
    );
  }
}
