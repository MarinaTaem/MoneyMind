import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mind/models/connect_database.dart';
// import 'package:money_mind/data/categories.dart';
import 'package:money_mind/models/data_models.dart';
//import 'package:money_mind/models/record_database.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  late DatabaseHelper _recordDatabase;
  List<Category> _icomeCategories = [];

  bool isSelected = false;

  final _formkey = GlobalKey<FormState>();
  final TextEditingController _amountCtr = TextEditingController();
  final TextEditingController _noteCtr = TextEditingController();
  Category? selectedIncomeCategory;

  String amountString = '';
  DateTime date = DateTime.now();

  double amount = 0;
  int _selectedIndex = 0;
  String formattedDate = '';
  String note = '';

  void _addIncome() async {
    amount = double.parse(_amountCtr.text.toString());
    note = _noteCtr.text;

    if (_formkey.currentState!.validate()) {
      await _recordDatabase.insertRecord(
          1, 'income', _selectedIndex, amount, formattedDate, note);
    }
  }

  void convertData() {
    amount = double.parse(_amountCtr.text.toString());
    note = _noteCtr.text;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd-MM-yyyy').format(date);

    _recordDatabase = DatabaseHelper();
    //Load Categories
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    _icomeCategories =
        await _recordDatabase.getIncomeCategories(type: CategoryType.income);
    print('NUMBER OF INCOME CATEGORIES: ${_icomeCategories.length}');
    print(
        'INCOME CATEGORIES: $_icomeCategories'); // Debug print to check the content
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount
              Form(
                key: _formkey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      child: TextFormField(
                        controller: _amountCtr,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
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
              // Category
              SizedBox(
                height: 200, // Set a height that fits your design
                child: _icomeCategories.isEmpty
                    ? Center(
                        child: Text('No income categories available.'),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 4,
                            childAspectRatio: 1.0),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return _widgetCategory(
                              _icomeCategories[index], index);
                        },
                      ),
              ),
              // -------- DATE ------------
              Text(
                'Date',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),

              Center(
                child: Container(
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
                        onPressed: () {
                          // setState(() {
                          //   _showCalendarDialog(context);
                          // });
                          _showCalendarDialog(context);
                        },
                        icon: Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Comment
              Text(
                'Comments',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      label: Text('Comments'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              //Save
              Center(
                child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async {
                      _addIncome();
                    },
                    child: Text('Save'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100), // Set your desired height here
      child: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.amber,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.turn_left)),
        title: Text('Add Income'),
        centerTitle: true,
      ),
    );
  }

  // Widget category
  Widget _widgetCategory(Category cat, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              cat.icon,
              width: 50,
              height: 50,
              color: isSelected
                  ? Colors.yellow
                  : const Color.fromARGB(255, 90, 82, 10),
              colorBlendMode: BlendMode.srcIn,
            ),
            SizedBox(height: 4),
            Text(
              cat.name,
              style: TextStyle(
                fontSize: 16,
                color: isSelected
                    ? Colors.yellow
                    : const Color.fromARGB(255, 90, 82, 10),
              ),
            ),
          ],
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
                  Container(
                    width: 300,
                    height: 300,
                    child: CalendarDatePicker(
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3000),
                      onDateChanged: (value) {
                        setState(() {
                          selectedDate =
                              value; // Update the local selected date
                        });
                      },
                    ),
                  ),
                  Text(
                    'Selected date: ${DateFormat.yMMMMd('en_US').format(selectedDate)}',
                  ), // Display the selected date
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      date = selectedDate; // Update the main date when done
                      formattedDate = DateFormat.yMMMMd('en_US').format(date);
                    });
                    Navigator.of(context).pop(); // Close the dialog
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
