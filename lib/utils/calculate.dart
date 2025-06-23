import 'package:money_mind/models/data_models.dart';

Map<String, List<double>> calculateDailyTotals(List<Transaction> transactions) {
  // Initialize maps to store totals for each day
  final income = List<double>.filled(7, 0);
  final expense = List<double>.filled(7, 0);

  // Get current date and calculate start of week (Monday)
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

  for (var transaction in transactions) {
    // Check if transaction is within current week
    if (transaction.dateRecord
        .isAfter(startOfWeek.subtract(const Duration(days: 1)))) {
      final dayIndex = transaction.dateRecord.weekday - 1; // 0=Monday, 6=Sunday

      if (transaction.budgetType == 'expense') {
        expense[dayIndex] += transaction.amount;
      } else {
        income[dayIndex] += transaction.amount;
      }
    }
  }

  return {
    'income': income,
    'expense': expense,
  };
}

Map<String, List<double>> calculateWeeklyTotals(
    List<Transaction> transactions) {
  // Initialize maps to store totals for each week
  final income = List<double>.filled(4, 0);
  final expense = List<double>.filled(4, 0);

  // Get current date and calculate start of month
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);

  for (var transaction in transactions) {
    // Check if transaction is within current month
    if (transaction.dateRecord
        .isAfter(startOfMonth.subtract(const Duration(days: 1)))) {
      final weekIndex = ((transaction.dateRecord.day - 1) / 7).floor();

      if (transaction.budgetType == 'expense') {
        expense[weekIndex] += transaction.amount;
      } else {
        income[weekIndex] += transaction.amount;
      }
    }
  }

  return {
    'income': income,
    'expense': expense,
  };
}

Map<String, List<double>> calculateMonthlyTotals(
    List<Transaction> transactions) {
  // Initialize maps to store totals for each month
  final income = List<double>.filled(12, 0);
  final expense = List<double>.filled(12, 0);

  // Get current date
  final now = DateTime.now();

  for (var transaction in transactions) {
    // Check if transaction is within current year
    if (transaction.dateRecord.year == now.year) {
      final monthIndex =
          transaction.dateRecord.month - 1; // 0=January, 11=December

      if (transaction.budgetType == 'expense') {
        expense[monthIndex] += transaction.amount;
      } else {
        income[monthIndex] += transaction.amount;
      }
    }
  }

  return {
    'income': income,
    'expense': expense,
  };
}

Map<String, List<double>> calculateYearlyTotals(
    List<Transaction> transactions) {
  // Initialize maps to store totals for each year
  final income = <int, double>{};
  final expense = <int, double>{};

  for (var transaction in transactions) {
    final year = transaction.dateRecord.year;

    if (transaction.budgetType == 'expense') {
      expense[year] = (expense[year] ?? 0) + transaction.amount;
    } else {
      income[year] = (income[year] ?? 0) + transaction.amount;
    }
  }

  // Convert maps to lists sorted by year
  final sortedYears = income.keys.toList()..sort();
  final incomeList = sortedYears.map((year) => income[year] ?? 0).toList();
  final expenseList = sortedYears.map((year) => expense[year] ?? 0).toList();

  return {
    'income': incomeList,
    'expense': expenseList,
  };
}
