import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mind/Screen/calculator_screen.dart';
import 'package:money_mind/models/connect_database.dart';
import 'package:money_mind/models/data_models.dart';
import 'package:money_mind/styles/color.dart';

class AddExpand extends StatefulWidget {
  const AddExpand({super.key});

  @override
  State<AddExpand> createState() => _AddExpandState();
}

class _AddExpandState extends State<AddExpand> {
  late DatabaseHelper _recordDatabase;
  late Budget _budget;
  List<Category> _expandCategories = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountCtr = TextEditingController();
  final TextEditingController _noteCtr = TextEditingController();
  Category? selectedExpandCategory;

  String formattedDate = '';
  DateTime date = DateTime.now();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd-MM-yyyy').format(date);
    _recordDatabase = DatabaseHelper();
    _budget = Budget();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      var categories =
          await _recordDatabase.getIncomeCategories(type: CategoryType.expense);
      setState(() {
        _expandCategories = categories;
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  void _addExpand() async {
    if (_formKey.currentState!.validate()) {
      if (selectedExpandCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      double amount = double.parse(_amountCtr.text);
      String note = _noteCtr.text;

      Transaction transaction = Transaction(
        amount: amount,
        note: note,
        dateRecord: date,
        category: selectedExpandCategory!,
        budgetType: 'expense',
      );

      _budget.addExpense(transaction);

      await _recordDatabase.insertRecord(
        1, // Replace with actual user ID
        'expense',
        selectedExpandCategory!.id,
        amount,
        formattedDate,
        note,
      );

      Navigator.pop(context, transaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CalculatorScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.calculate)),
                      SizedBox(width: 10),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: _amountCtr,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount';
                            }
                            return null;
                          },
                        ),
                      ),
                      Text(
                        'Riels',
                        style: TextStyle(fontSize: 24),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Category',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: _expandCategories.isEmpty
                      ? Center(child: Text('No Expense categories available.'))
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 4,
                            childAspectRatio: 1.0,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemCount: _expandCategories.length,
                          itemBuilder: (context, index) {
                            return _widgetCategory(
                                _expandCategories[index], index);
                          },
                        ),
                ),
                Text(
                  'Date',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                Center(
                  child: SizedBox(
                    width: 250,
                    height: 50,
                    child: Row(
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () => _showCalendarDialog(context),
                          icon: Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Comments',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _noteCtr,
                      decoration: InputDecoration(
                        label: Text('Comments'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: _addExpand,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor),
                      child: Text('Save'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.turn_left),
        ),
        title: Text('Add Expand'),
        centerTitle: true,
      ),
    );
  }

  Widget _widgetCategory(Category cat, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          selectedExpandCategory = cat;
        });
      },
      child: SizedBox(
        // width: 60,
        // height: 60,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                cat.icon,
                width: 50,
                height: 50,
                color: isSelected
                    ? AppColors.primaryColor
                    : const Color.fromARGB(255, 90, 82, 10),
                colorBlendMode: BlendMode.srcIn,
              ),
              const SizedBox(height: 4),
              Text(
                cat.name,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected
                      ? AppColors.primaryColor
                      : const Color.fromARGB(255, 90, 82, 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCalendarDialog(BuildContext context) {
    DateTime selectedDate = date;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Select Date'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: CalendarDatePicker(
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3000),
                      onDateChanged: (value) {
                        setState(() {
                          selectedDate = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Selected date: ${DateFormat.yMMMMd('en_US').format(selectedDate)}',
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      date = selectedDate;
                      formattedDate = DateFormat('dd-MM-yyyy').format(date);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
