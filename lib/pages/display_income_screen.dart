import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mind/Screen/add_income.dart';
import 'package:money_mind/models/connect_database.dart';
import 'package:money_mind/styles/color.dart';
import 'package:money_mind/widgets/record_widget.dart';
import 'package:money_mind/models/data_models.dart';

class DisplayIncomeScreen extends StatefulWidget {
  // final List<Transaction>? transactions;
  final int userId;
  final DateTime selectedDate;

  const DisplayIncomeScreen({
    super.key,
    required this.userId,
    // this.transactions,
    required this.selectedDate,
  });

  @override
  State<DisplayIncomeScreen> createState() => _DisplayIncomeScreenState();
}

class _DisplayIncomeScreenState extends State<DisplayIncomeScreen> {
  late Budget budget;
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    budget = Budget();
    _loadTransactions();
  }

  @override
  void didUpdateWidget(DisplayIncomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload records if the selectedDate changes
    if (widget.selectedDate != oldWidget.selectedDate) {
      _loadTransactions();
    }
  }

  DateTime parseDate(String date) {
    final formats = [
      DateFormat('dd-MM-yyyy'),
      DateFormat('MMMM d, yyyy'),
    ];
    for (var format in formats) {
      try {
        return format.parse(date);
      } catch (e) {}
    }
    throw FormatException('Unsupported date format: $date');
  }

  Future<void> _loadTransactions() async {
    try {
      final records = await _databaseHelper.getRecordsForUser(widget.userId);
      print('Raw records: $records');

      setState(() {
        budget.income = records
            .where((record) => record['budget_type'] == 'income')
            .map((record) {
          Category category = Category.fromMap({
            'category_id': record['category_id'],
            'name': record['category_name'],
            'icon': record['category_icon'],
            'type': record['category_type']
          });

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
            budgetType: 'income',
          );
        }).toList();

        // Filter transactions for the selected month and year
        budget.income = budget.income.where((transaction) {
          return transaction.dateRecord.year == widget.selectedDate.year &&
              transaction.dateRecord.month == widget.selectedDate.month;
        }).toList();

        // Recalculate total income
        budget.totalIncome =
            budget.income.fold(0, (sum, item) => sum + item.amount);
      });
    } catch (e) {
      print('Error in _loadTransactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            widgetTotal(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                scrollDirection: Axis.vertical,
                itemCount: budget.income.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecordWidget(transaction: budget.income[index]);
                },
                separatorBuilder: (BuildContext context, index) =>
                    const Divider(),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTransaction = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddIncome()),
          );
          if (newTransaction != null) {
            setState(() {
              budget.income.add(newTransaction);
              budget.totalIncome += newTransaction.amount;
            });
          }
        },
        backgroundColor: const Color.fromARGB(255, 137, 123, 4),
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Total',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 30),
          Text(
            budget.totalIncome.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
