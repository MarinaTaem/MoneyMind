// import 'package:sqflite/sqflite.dart';
import 'connect_database.dart'; // Ensure this path is correct
// import 'data_models.dart'; // Ensure this path is correct

class DataModel {
  List<Transaction> income = [];
  List<Transaction> expense = [];
  double totalIncome = 0;
  double totalExpense = 0;
  double balance = 0;

  final DatabaseHelper dbHelper = DatabaseHelper();

  void addIncome(Transaction transaction) async {
    if (transaction.typeBudget == BudgetType.income) {
      income.add(transaction);
      totalIncome += transaction.amount;
      _updateBalance();

      // Insert the transaction into the database
      await dbHelper.insertRecord(
        transaction.accountId,
        transaction.typeBudget.toString(),
        transaction.categoryId,
        transaction.amount,
        transaction.date.toIso8601String(),
        transaction.description,
      );
    }
  }

  void addExpense(Transaction transaction) async {
    if (transaction.typeBudget == BudgetType.expense) {
      expense.add(transaction);
      totalExpense += transaction.amount;
      _updateBalance();

      // Insert the transaction into the database
      await dbHelper.insertRecord(
        transaction.accountId,
        transaction.typeBudget.toString(),
        transaction.categoryId,
        transaction.amount,
        transaction.date.toIso8601String(),
        transaction.description,
      );
    }
  }

  void _updateBalance() {
    balance = totalIncome - totalExpense;
  }

  Future<void> loadInitialData(int userId) async {
    final records = await dbHelper.getRecordsForUser(userId);
    for (var record in records) {
      final transaction = Transaction.fromMap(record);
      if (transaction.typeBudget == BudgetType.income) {
        income.add(transaction);
        totalIncome += transaction.amount;
      } else if (transaction.typeBudget == BudgetType.expense) {
        expense.add(transaction);
        totalExpense += transaction.amount;
      }
    }
    _updateBalance();
  }
}

class Transaction {
  final int accountId;
  final double amount;
  final BudgetType typeBudget;
  final int categoryId;
  final DateTime date;
  final String description;

  Transaction({
    required this.accountId,
    required this.amount,
    required this.typeBudget,
    required this.categoryId,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'account_id': accountId,
      'amount': amount,
      'budget_type': typeBudget.index,
      'category_id': categoryId,
      'date': date.toIso8601String(),
      'note': description,
    };
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      accountId: map['account_id'],
      amount: map['amount'],
      typeBudget: BudgetType.values[map['budget_type']],
      categoryId: map['category_id'],
      date: DateTime.parse(map['date']),
      description: map['note'] ?? '',
    );
  }
}

enum BudgetType { income, expense }
