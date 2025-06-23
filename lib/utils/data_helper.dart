import 'package:money_mind/models/connect_database.dart';
import 'package:money_mind/models/data_models.dart';
import 'package:money_mind/utils/helper_date.dart';

Future<List<Transaction>> loadTransactions({
  required int userId,
  required Budget budget,
  DatabaseHelper? dbHelperOverride,
}) async {
  final dbHelper = dbHelperOverride ?? DatabaseHelper();
  List<Transaction> transactions = [];

  try {
    final records = await dbHelper.getRecordsForUser(userId);

    transactions = records.map((record) {
      final category = Category(
        id: record['category_id'],
        name: record['category_name'],
        icon: record['category_icon'],
        type: CategoryType.values[record['category_type']],
      );

      final dateRecord = record['date'] is String
          ? parseDate(record['date'])
          : record['date'] is DateTime
              ? record['date']
              : throw FormatException('Invalid date format: ${record['date']}');

      return Transaction(
        id: record['record_id'],
        amount: record['amount'],
        note: record['note'] ?? '',
        dateRecord: dateRecord,
        category: category,
        budgetType: record['budget_type'],
      );
    }).toList();

    transactions.sort((a, b) => b.dateRecord.compareTo(a.dateRecord));

    for (var transaction in transactions) {
      if (transaction.budgetType == 'income') {
        budget.addIncome(transaction);
      } else {
        budget.addExpense(transaction);
      }
    }
  } catch (e) {
    print('Error loading transactions: $e');
  }

  return transactions;
}
