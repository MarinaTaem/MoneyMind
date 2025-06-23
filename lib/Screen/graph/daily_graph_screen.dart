import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:money_mind/models/connect_database.dart';
import 'package:money_mind/models/data_models.dart';
import 'package:money_mind/utils/calculate.dart';
import 'package:money_mind/utils/data_helper.dart';
// import 'package:money_mind/utils/helper_date.dart';
import 'package:money_mind/widgets/record_graph_widget.dart';
import 'package:money_mind/widgets/summary_card.dart';

class DailyGraphScreen extends StatefulWidget {
  final int userId;
  final List<Transaction>? transaction;
  DailyGraphScreen({super.key, required this.userId, this.transaction});

  @override
  State<DailyGraphScreen> createState() => _DailyGraphScreenState();
}

class _DailyGraphScreenState extends State<DailyGraphScreen> {
  late List<Transaction> transactions;
  late List<double> income = List.filled(7, 0);
  late List<double> expense = List.filled(7, 0);
  late Budget budget;
  DateTime dailyDate = DateTime.now();

  double totalMon(String type, int day) {
    double total = 0;
    for (var tx in transactions) {
      if (tx.dateRecord.weekday == day && tx.budgetType == type) {
        total = budget.balance;
      }
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      transactions = widget.transaction ?? [];
    });

    budget = Budget();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    transactions =
        await loadTransactions(userId: widget.userId, budget: budget);
    setState(() {});
  }

  double getMaxY() {
    final maxExpense = barGroups
        .expand((group) => group.barRods)
        .map((rod) => rod.toY)
        .reduce(max);
    return maxExpense * 1.2; // 20% padding
  }

  @override
  Widget build(BuildContext context) {
    final dailyTotal = calculateDailyTotals(transactions);
    income = dailyTotal['income']!;
    expense = dailyTotal['expense']!;

    final now = DateTime.now();

    // Calculate the start and end of the current week (Monday to Sunday)
    final int currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday
    final DateTime weekStart = now.subtract(Duration(days: currentWeekday - 1));
    final DateTime weekEnd = weekStart.add(const Duration(days: 6));

    // Filter transactions for the current week
    final currentWeekTransactions = transactions.where((t) {
      final date = t.dateRecord;
      return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          date.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();

    // Grouping logic for transactions by category
    final Map<int, List<Transaction>> groupedTransactions = {};
    for (final transaction in currentWeekTransactions) {
      final catId = transaction.category.id;
      if (!groupedTransactions.containsKey(catId)) {
        groupedTransactions[catId] = [];
      }
      groupedTransactions[catId]!.add(transaction);
    }
    // If you need the Category object for the SummaryCard, store it separately:
    final Map<int, Category> categoryMap = {
      for (var t in transactions) t.category.id: t.category
    };
    // Then build your summary cards:
    groupedTransactions.entries.map((entry) => SummaryCard(
          category: categoryMap[entry.key]!,
          transactions: entry.value,
        ));

    return SizedBox(
      width: double.infinity,
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // bar chart
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 14),
                    child: BarChart(
                      duration: const Duration(milliseconds: 300),
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        backgroundColor:
                            const Color.fromARGB(255, 155, 181, 226),
                        // barTouchData: barTouchData,
                        barGroups: barGroups,
                        // gridData: const FlGridData(show: false),
                        titlesData: titlesData,
                        borderData: borderData,
                        maxY: getMaxY(),
                        minY: 0,
                        // barTouchData: BarTouchData(
                        //     touchTooltipData:
                        //         BarTouchTooltipData(fitInsideHorizontally: true)),
                      ),
                    ),
                  ),
                ),
              ),
              // Total Income and Expense
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: SvgPicture.asset(
                            'assets/icons/total_income.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Text(
                          'Income',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          budget.totalIncome.toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: SvgPicture.asset(
                            'assets/icons/total_expense.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Text(
                          'Expense',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          budget.totalExpense.toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                children: [
                  const Text(
                    'Transaction Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Sort categories by total amount (descending)
                  ...(() {
                    final sortedCategoryEntries =
                        groupedTransactions.entries.toList()
                          ..sort((a, b) {
                            final totalA =
                                a.value.fold(0.0, (sum, t) => sum + t.amount);
                            final totalB =
                                b.value.fold(0.0, (sum, t) => sum + t.amount);
                            return totalB.compareTo(totalA);
                          });
                    return sortedCategoryEntries.map((entry) => SummaryCard(
                          category: categoryMap[entry.key]!,
                          transactions: entry.value,
                        ));
                  })(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    final titles = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: text,
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: _bottomTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border.all(
          color: const Color.fromARGB(255, 244, 3, 3),
          width: 0,
        ),
      );

  LinearGradient get _expenseBarGradient => const LinearGradient(
        colors: [
          Colors.red,
          Colors.redAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get _incomeBarGradient => const LinearGradient(
        colors: [
          Colors.green,
          Colors.greenAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => List.generate(
        7,
        (index) {
          return BarChartGroupData(
            x: index,
            barsSpace: 5,
            barRods: [
              BarChartRodData(
                toY: income[index],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                ),
                gradient: _incomeBarGradient,
              ),
              BarChartRodData(
                toY: expense[index],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                ),
                gradient: _expenseBarGradient,
              ),
            ],
          );
        },
      );
}
