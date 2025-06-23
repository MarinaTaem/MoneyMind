// import 'package:money_mind/data/categories.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:money_mind/models/data_models.dart'; // Import your Category model

// class RecordDatabase {
//   static Database? _record;

//   Future<Database> get database async {
//     if (_record != null) return _record!;
//     _record = await _initDatabase();
//     return _record!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'pp_database.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         // Create the categories table
//         await db.execute('''
//           CREATE TABLE categories (
//             category_id INTEGER PRIMARY KEY AUTOINCREMENT,
//             name TEXT NOT NULL,
//             icon TEXT NOT NULL,
//             type TEXT NOT NULL
//           )
//         ''');

//         // Create the records table
//         await db.execute('''
//           CREATE TABLE records (
//             record_id INTEGER PRIMARY KEY AUTOINCREMENT,
//             account_id INTEGER,
//             budget_type TEXT NOT NULL,
//             category_id INTEGER,
//             amount REAL NOT NULL,
//             date TEXT NOT NULL,
//             note TEXT,
//             FOREIGN KEY (account_id) REFERENCES accounts(user_id),
//             FOREIGN KEY (category_id) REFERENCES categories(category_id)
//           )
//         ''');
//         await _insertPredefinedCategories(db);
//       },
//     );
//   }

//   Future<void> _insertPredefinedCategories(Database db) async {
//     for (var category in categories) {
//       await db.insert(
//         'categories',
//         {
//           'name': category.name,
//           'icon': category.icon,
//           'type': category.type.toString(), // Assuming CategoryType is an enum
//         },
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     }
//   }

//   Future<List<Category>> getIncomeCategories({CategoryType? type}) async {
//     final db = await database;
//     List<Map<String, dynamic>> categoryMaps;

//     if (type != null) {
//       // If a type is provided, filter categories by type
//       categoryMaps = await db.query(
//         'categories',
//         where: 'type = ?',
//         whereArgs: [type.toString()],
//       );
//     } else {
//       // If no type is provided, get all categories
//       categoryMaps = await db.query('categories');
//     }

//     return List.generate(categoryMaps.length, (i) {
//       return Category(
//         name: categoryMaps[i]['name'],
//         icon: categoryMaps[i]['icon'],
//         type: categoryMaps[i]['type'] == 'CategoryType.income'
//             ? CategoryType.income
//             : CategoryType.expense,
//       );
//     });
//   }

//   Future<void> insertRecord(int accountId, String budgetType, int categoryId,
//       double amount, String date, String note) async {
//     final db = await database;
//     await db.insert(
//       'records',
//       {
//         'account_id': accountId,
//         'budget_type': budgetType,
//         'category_id': categoryId,
//         'amount': amount,
//         'date': date,
//         'note': note,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   // Display records with category names
//   Future<List<Map<String, dynamic>>> getRecord() async {
//     final db = await database;
//     final List<Map<String, dynamic>> records = await db.rawQuery('''
//       SELECT records.amount, records.budget_type, categories.name AS category_name, records.date, records.note
//       FROM records
//       LEFT JOIN categories ON records.category_id = categories.category_id
//     ''');
//     return records;
//   }
// }
