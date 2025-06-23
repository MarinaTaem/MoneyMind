class Transaction {
  late int? id; // Added optional id for database record
  late double amount;
  late String note; // Changed from description to match database schema
  late DateTime dateRecord;
  late Category category;
  late String budgetType; // Changed from typeBudget to match database schema

  Transaction({
    this.id, // Made optional
    required this.amount,
    required this.note,
    required this.dateRecord,
    required this.category,
    required this.budgetType,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'record_id': id, // Include record_id if it exists
      'amount': amount,
      'budget_type': budgetType,
      'category_id': category.id,
      'date': dateRecord.toIso8601String(),
      'note': note,
    };
  }

  static Transaction fromMap(Map<String, dynamic> map, Category category) {
    return Transaction(
      id: map['record_id'],
      amount: map['amount'],
      note: map['note'] ?? '',
      dateRecord: DateTime.parse(map['date']),
      category: category,
      budgetType: map['budget_type'],
    );
  }
}

// You can keep the existing enums and other classes as they were
enum BudgetType { income, expense }

enum CategoryType { income, expense }

class Category {
  final int id;
  final String name;
  final String icon;
  final CategoryType type;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_id': id, // Changed to match database schema
      'name': name,
      'icon': icon,
      'type': type.index,
    };
  }

  Category.fromMap(Map<String, dynamic> map)
      : id = map['category_id'] ?? 0, // Changed to match database schema
        name = map['name'] ?? "",
        icon = map['icon'] ?? "",
        type = CategoryType.values[map['type'] ?? 0];
}

class Budget {
  double totalIncome;
  double totalExpense;
  double balance;
  List<Transaction> income;
  List<Transaction> expense;

  Budget()
      : totalIncome = 0.0,
        totalExpense = 0.0,
        balance = 0.0,
        income = [],
        expense = [];

  void addIncome(Transaction transaction) {
    if (transaction.budgetType == 'income') {
      income.add(transaction);
      totalIncome += transaction.amount;
      _updateBalance();
    }
  }

  void addExpense(Transaction transaction) {
    if (transaction.budgetType == 'expense') {
      expense.add(transaction);
      totalExpense += transaction.amount;
      _updateBalance();
    }
  }

  void _updateBalance() {
    balance = totalIncome - totalExpense;
  }
}
