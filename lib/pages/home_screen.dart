import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mind/models/connect_database.dart';
import 'package:money_mind/models/data_models.dart';
import 'package:money_mind/pages/display_expense_screen.dart';
import 'package:money_mind/pages/display_income_screen.dart';
import 'package:money_mind/pages/home_screen_all.dart';
import 'package:money_mind/styles/color.dart';
import 'package:money_mind/widgets/text_style.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  final List<Transaction>? transactions;

  const HomeScreen({super.key, required this.userId, this.transactions});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Transaction> transactions;
  DateTime currentDate = DateTime.now();

  late Budget budget;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    transactions = widget.transactions ?? [];
  }

  Future<void> _loadRecords() async {
    try {
      final dbHelper = DatabaseHelper();
      final records = await dbHelper.getRecordsForUser(widget.userId);
      debugPrint('Raw records: $records');

      // Convert records to Transaction objects
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
        return transaction.dateRecord.year == currentDate.year &&
            transaction.dateRecord.month == currentDate.month;
      }).toList();
      debugPrint("currentDate: ${currentDate.month}");

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
      debugPrint('Error in _loadTransactions: $e');
      setState(() {
        isLoading = false;
      });
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

  List<String> monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  // String currentMonthName = monthNames[currentDate.month - 1];
  String currentMonthName() {
    return monthNames[currentDate.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: widgetTitle(),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              setState(() {
                if (currentDate.month > 1) {
                  currentDate =
                      DateTime(currentDate.year, currentDate.month - 1);
                } else {
                  currentDate = DateTime(currentDate.year - 1, 12);
                }
              });
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  // Move to the next month
                  if (currentDate.month < 12) {
                    currentDate =
                        DateTime(currentDate.year, currentDate.month + 1);
                  } else {
                    currentDate = DateTime(currentDate.year + 1, 1);
                  }
                });
                _loadRecords();
              },
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                text: 'All',
              ),
              Tab(text: 'Income'),
              Tab(text: 'Expense'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: HomeScreenAll(
              userId: widget.userId,
              transactions: transactions,
              selectedDate: currentDate, // Pass the current date
            ),
          ),
          Center(
            child: DisplayIncomeScreen(
              userId: widget.userId,
              // transactions: transactions,
              selectedDate: currentDate,
            ),
          ),
          Center(
            child: DisplayExpenseScreen(
              userId: widget.userId,
              transactions: transactions,
              selectedDate: currentDate,
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetTitle() {
    return Center(
      child: SizedBox(
        height: 70,
        child: Center(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 0,
                child: textHeader(content: currentMonthName()).build(),
              ),
              Positioned(
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.calendar_month,
                          weight: 10,
                        )),
                    Text(
                      '${currentDate.year}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
