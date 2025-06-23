import 'package:money_mind/models/data_helper.dart';

class DailyTime {
  double? mon = 0.0;
  double? tue = 0.0;
  double? wed = 0.0;
  double? thu = 0.0;
  double? fri = 0.0;
  double? sat = 0.0;
  double? sun = 0.0;

  DailyTime({
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.fri,
    this.sat,
    this.sun,
  });
}

List<List<double>> getDaily(List<Transaction> transactions) {
  // Initialize list for 7 days: Sunday (0) to Saturday (6)
  List<double> weekdayIncome = List.filled(7, 0);
  List<double> weekdayExpense = List.filled(7, 0);

  for (var tx in transactions) {
    int weekdayIndex =
        tx.date.weekday % 7; // Sunday = 0, Monday = 1, ..., Saturday = 6
    if (tx.typeBudget == BudgetType.income) {
      weekdayIncome[weekdayIndex] += tx.amount;
    } else {
      weekdayExpense[weekdayIndex] += tx.amount;
    }
  }

  // Return both lists together
  return [weekdayIncome, weekdayExpense];
}

List<Transaction> filterThisWeek(List<Transaction> transactions) {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = now.add(Duration(days: 7 - now.weekday));

  return transactions.where((tx) {
    return tx.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        tx.date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }).toList();
}
