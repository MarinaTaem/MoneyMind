import 'package:flutter/material.dart';
import 'package:money_mind/models/connect_database.dart';
import 'package:money_mind/models/data_models.dart';

class Catgories extends StatefulWidget {
  const Catgories({super.key});

  @override
  State<Catgories> createState() => _CatgoriesState();
}

class _CatgoriesState extends State<Catgories> {
  late DatabaseHelper _recordDatabase;
  var _icomeCategories = [];

  @override
  void initState() {
    super.initState();
    _recordDatabase = DatabaseHelper();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    print('Loading categories...');
    try {
      var jsonCategories =
          await _recordDatabase.getIncomeCategories(type: CategoryType.income);

      setState(() {
        _icomeCategories = jsonCategories;
      });

      print('NUMBER OF INCOME CATEGORIES: ${_icomeCategories.length}');
      print('INCOME CATEGORIES: $_icomeCategories');
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income Categories'),
      ),
      body: _icomeCategories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _icomeCategories.length,
              itemBuilder: (context, index) {
                var category = _icomeCategories[index];
                return ListTile(
                  title: Text(category.name),
                  leading: Image.asset(category.icon),
                );
              },
            ),
    );
  }
}
