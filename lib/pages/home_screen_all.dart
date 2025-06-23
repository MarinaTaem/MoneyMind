import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mind/models/connect_database.dart';
import 'package:money_mind/models/data_models.dart';
import 'package:money_mind/styles/color.dart';
import 'package:money_mind/utils/helper_date.dart';
import 'package:money_mind/widgets/record_widget.dart';

class HomeScreenAll extends StatefulWidget {
  final int userId;
  final List<Transaction> transactions;
  final DateTime selectedDate;

  const HomeScreenAll({
    super.key,
    required this.userId,
    required this.transactions,
    required this.selectedDate,
  });

  @override
  State<HomeScreenAll> createState() => _HomeScreenAllState();
}

class _HomeScreenAllState extends State<HomeScreenAll> {
  late List<Transaction> transactions;
  late Budget budget;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    transactions = widget.transactions;
    budget = Budget();
    _loadRecords();
  }

  @override
  void didUpdateWidget(HomeScreenAll oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _loadRecords();
    }
  }

  Future<void> _loadRecords() async {
    setState(() {
      isLoading = true;
    });

    try {
      final dbHelper = DatabaseHelper();
      final records = await dbHelper.getRecordsForUser(widget.userId);
      print('Raw records: $records');

      transactions = records.map((record) {
        Category category = Category(
          id: record['category_id'],
          name: record['category_name'],
          icon: record['category_icon'],
          type: CategoryType.values[record['category_type']],
        );

        DateTime dateRecord;
        if (record['date'] is String) {
          dateRecord = parseDate(record['date']);
        } else if (record['date'] is DateTime) {
          dateRecord = record['date'];
        } else {
          throw FormatException('Invalid date format: ${record['date']}');
        }

        return Transaction(
          id: record['record_id'],
          amount: record['amount'],
          note: record['note'] ?? '',
          dateRecord: dateRecord,
          category: category,
          budgetType: record['budget_type'],
        );
      }).toList();

      // Filter transactions for the selected month and year
      transactions = transactions.where((transaction) {
        return transaction.dateRecord.year == widget.selectedDate.year &&
            transaction.dateRecord.month == widget.selectedDate.month;
      }).toList();

      // Sort transactions by date in descending order
      transactions.sort((a, b) => b.dateRecord.compareTo(a.dateRecord));

      // Add transactions to the budget
      for (var transaction in transactions) {
        if (transaction.budgetType == 'income') {
          budget.addIncome(transaction);
        } else {
          budget.addExpense(transaction);
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error in _loadTransactions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    DateTime currentDate = DateTime.now();
    final String currentDateKey = DateFormat('yyyy-MM-dd').format(currentDate);

    // Group transactions by date
    final Map<String, List<Transaction>> groupedTransactions = {};
    for (var transaction in transactions) {
      final dateKey = DateFormat('yyyy-MM-dd').format(transaction.dateRecord);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            widgetTotal(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                scrollDirection: Axis.vertical,
                itemCount: groupedTransactions.length,
                itemBuilder: (BuildContext context, int index) {
                  final dateKey = groupedTransactions.keys.elementAt(index);
                  final transactionsForDate = groupedTransactions[dateKey]!;
                  final String displayDate = dateKey == currentDateKey
                      ? 'Today'
                      : DateFormat('MMMM d, yyyy')
                          .format(DateTime.parse(dateKey));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          displayDate,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...transactionsForDate.map((transaction) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: RecordWidget(transaction: transaction),
                        );
                      }).toList(),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, index) =>
                    const Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetTotal() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  budget.totalIncome.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Text(
                  'Earned',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  budget.balance.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  'Balance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  budget.totalExpense.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Spent',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
