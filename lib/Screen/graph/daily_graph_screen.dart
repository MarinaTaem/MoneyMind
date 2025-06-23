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

    return SizedBox(
      width: 340,
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // bar chart
              AspectRatio(
                aspectRatio: 1.5,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  child: BarChart(
                    duration: const Duration(milliseconds: 300),
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      backgroundColor: const Color.fromARGB(255, 155, 181, 226),
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
              // list of income and expense
              const Row(children: [
                Text(
                  'Today',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  'Today',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              const SizedBox(
                height: 8,
              ),
              ListView.separated(
                itemBuilder: (context, index) {
                  return RecordGraphWidget(
                    transaction: transactions[index],
                  );
                },
                separatorBuilder: (BuildContext context, index) =>
                    const Divider(),
                itemCount: transactions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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

  Widget _leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1ម៉ឺន';
    } else if (value == 10) {
      text = '1ម៉ឺន';
    } else if (value == 19) {
      text = '1ម៉ឺន';
    } else {
      return Container();
    }

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
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
            showTitles: true,
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
