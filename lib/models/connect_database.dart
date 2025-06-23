// // import 'package:money_mind/data/categories.dart';
// // import 'package:money_mind/models/data_models.dart';
// // import 'package:sqflite/sqflite.dart';
// // import 'package:path/path.dart';

// // class DatabaseHelper {
// //   static Database? _database;

// //   Future<Database> get database async {
// //     if (_database != null) return _database!;
// //     _database = await _initDatabase();
// //     return _database!;
// //   }

// //   Future<Database> _initDatabase() async {
// //     String path = join(await getDatabasesPath(), 'database_1.db');
// //     return await openDatabase(
// //       path,
// //       version: 1, // Increment this if you change the schema
// //       onCreate: (db, version) async {
// //         // Create the users table
// //         await db.execute('''
// //           CREATE TABLE users (
// //             user_id INTEGER PRIMARY KEY AUTOINCREMENT,
// //             username TEXT UNIQUE NOT NULL,
// //             password TEXT NOT NULL
// //           )
// //         ''');

// //         // Create the categories table
// //         await db.execute('''
// //           CREATE TABLE categories (
// //             category_id INTEGER PRIMARY KEY AUTOINCREMENT,
// //             name TEXT NOT NULL,
// //             icon TEXT NOT NULL,
// //             type TEXT NOT NULL
// //           )
// //         ''');

// //         // Create the records table
// //         await db.execute('''
// //           CREATE TABLE records (
// //             record_id INTEGER PRIMARY KEY AUTOINCREMENT,
// //             account_id INTEGER,
// //             budget_type TEXT NOT NULL,
// //             category_id INTEGER,
// //             amount REAL NOT NULL,
// //             date TEXT NOT NULL,
// //             note TEXT,
// //             FOREIGN KEY (account_id) REFERENCES users(user_id),
// //             FOREIGN KEY (category_id) REFERENCES categories(category_id)
// //           )
// //         ''');
// //         _insertPredefinedCategories(db);
// //       },
// //     );
// //   }

// //   // User-related methods
// //   Future<int> registerUser(String username, String password) async {
// //     final db = await database;
// //     try {
// //       return await db.insert(
// //         'users',
// //         {'username': username, 'password': password},
// //       );
// //     } catch (e) {
// //       print('Error during registration: $e');
// //       return -1; // Indicate failure
// //     }
// //   }

// //   Future<int?> loginUser(String username, String password) async {
// //     final db = await database;
// //     final result = await db.query(
// //       'users',
// //       where: 'username = ? AND password = ?',
// //       whereArgs: [username, password],
// //     );

// //     if (result.isNotEmpty) {
// //       return result.first['user_id'] as int;
// //     }
// //     return null;
// //   }

// //   Future<void> _insertPredefinedCategories(Database db) async {
// //     for (var category in categories) {
// //       await db.insert(
// //         'categories',
// //         {
// //           'name': category.name,
// //           'icon': category.icon,
// //           'type': category.type.toString(), // Assuming CategoryType is an enum
// //         },
// //         conflictAlgorithm: ConflictAlgorithm.replace,
// //       );
// //     }
// //   }

// //   Future<List<Category>> getIncomeCategories({CategoryType? type}) async {
// //     final db = await database;
// //     List<Map<String, dynamic>> categoryMaps;

// //     if (type != null) {
// //       // If a type is provided, filter categories by type
// //       categoryMaps = await db.query(
// //         'categories',
// //         where: 'type = ?',
// //         whereArgs: [type.toString()],
// //       );
// //     } else {
// //       // If no type is provided, get all categories
// //       categoryMaps = await db.query('categories');
// //     }

// //     return List.generate(categoryMaps.length, (i) {
// //       return Category(
// //         name: categoryMaps[i]['name'],
// //         icon: categoryMaps[i]['icon'],
// //         type: categoryMaps[i]['type'] == 'CategoryType.income'
// //             ? CategoryType.income
// //             : CategoryType.expense,
// //       );
// //     });
// //   }

// //   // Record-related methods
// //   Future<void> insertRecord(int accountId, String budgetType, int categoryId,
// //       double amount, String date, String note) async {
// //     final db = await database;
// //     await db.insert(
// //       'records',
// //       {
// //         'account_id': accountId,
// //         'budget_type': budgetType,
// //         'category_id': categoryId,
// //         'amount': amount,
// //         'date': date,
// //         'note': note,
// //       },
// //       conflictAlgorithm: ConflictAlgorithm.replace,
// //     );
// //   }

// //   Future<List<Map<String, dynamic>>> getRecordsForUser(int userId) async {
// //     final db = await database;
// //     final List<Map<String, dynamic>> records = await db.rawQuery('''
// //       SELECT records.amount, records.budget_type, categories.name AS category_name, records.date, records.note
// //       FROM records
// //       LEFT JOIN categories ON records.category_id = categories.category_id
// //       WHERE records.account_id = ?
// //     ''', [userId]);
// //     return records;
// //   }
// // }

// import 'package:money_mind/models/data_models.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'database_1.db');
//     return await openDatabase(
//       path,
//       version: 1, // Increment this if you change the schema
//       onCreate: (db, version) async {
//         // Create the users table
//         await db.execute('''
//           CREATE TABLE users (
//             user_id INTEGER PRIMARY KEY AUTOINCREMENT,
//             username TEXT UNIQUE NOT NULL,
//             password TEXT NOT NULL
//           )
//         ''');

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
//             FOREIGN KEY (account_id) REFERENCES users(user_id),
//             FOREIGN KEY (category_id) REFERENCES categories(category_id)
//           )
//         ''');
//         // await _insertPredefinedCategories(db);
//       },
//     );
//   }

//   // User-related methods
//   Future<int> registerUser(String username, String password) async {
//     final db = await database;
//     try {
//       return await db.insert(
//         'users',
//         {'username': username, 'password': password},
//       );
//     } catch (e) {
//       print('Error during registration: $e');
//       return -1; // Indicate failure
//     }
//   }

//   Future<int?> loginUser(String username, String password) async {
//     final db = await database;
//     final result = await db.query(
//       'users',
//       where: 'username = ? AND password = ?',
//       whereArgs: [username, password],
//     );

//     if (result.isNotEmpty) {
//       return result.first['user_id'] as int;
//     }
//     return null;
//   }

//   // Future<void> _insertPredefinedCategories(Database db) async {
//   //   for (var category in categories) {
//   //     await db.insert(
//   //       'categories',
//   //       {
//   //         'name': category.name,
//   //         'icon': category.icon,
//   //         'type': category.type.index, // Assuming CategoryType is an enum
//   //       },
//   //       conflictAlgorithm: ConflictAlgorithm.replace,
//   //     );
//   //   }
//   //   final List<Map<String, dynamic>> result = await db.query('categories');
//   //   print('DATABASE CONTENT AFTER INSERTION: $result');
//   // }

//   // Future<List<Category>> getIncomeCategories({CategoryType? type}) async {
//   //   final db = await database;
//   //   List<Map<String, dynamic>> categoryMaps;

//   //   if (type != null) {
//   //     // If a type is provided, filter categories by type
//   //     categoryMaps = await db.query(
//   //       'categories',
//   //       where: 'type = ?',
//   //       whereArgs: [type.toString()],
//   //     );
//   //   } else {
//   //     // If no type is provided, get all categories
//   //     categoryMaps = await db.query('categories');
//   //   }

//   //   return List.generate(categoryMaps.length, (i) {
//   //     return Category(
//   //       id: categoryMaps[i]['id'],
//   //       name: categoryMaps[i]['name'],
//   //       icon: categoryMaps[i]['icon'],
//   //       type: categoryMaps[i]['type'] == 'CategoryType.income'
//   //           ? CategoryType.income
//   //           : CategoryType.expense,
//   //     );
//   //   });
//   // }

//   Future<void> printDatabaseContent() async {
//     final db = await database;
//     final List<Map<String, dynamic>> result = await db.query('categories');
//     print('CURRENT DATABASE CONTENT: $result');
//   }

//   Future<dynamic> returnTheCategory() async {
//     final db = await database;
//     final List<Map<String, dynamic>> result = await db.query('categories');
//     return result;
//   }

//   Future<List<Category>> getIncomeCategories({CategoryType? type}) async {
//     final db = await database;

//     await printDatabaseContent();

//     List<Map<String, dynamic>> categoryMaps;

//     if (type != null) {
//       // If a type is provided, filter categories by type
//       categoryMaps = await db.query(
//         'categories',
//         where: 'type = ?',
//         whereArgs: [type.index], // Use the index of the enum
//       );
//     } else {
//       // If no type is provided, get all categories
//       categoryMaps = await db.query('categories');
//     }

//     print('CATEGORY MAPS: $categoryMaps'); // Debug print

//     return List.generate(categoryMaps.length, (i) {
//       return Category(
//         categoryId: categoryMaps[i]['id'],
//         name: categoryMaps[i]['name'],
//         icon: categoryMaps[i]['icon'],
//         // type: CategoryType.values[categoryMaps[i]
//         //     ['type']], // Use the index to get the enum value
//         type: categoryMaps[i]['type'], //
//       );
//     });
//   }

//   // Record-related methods
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

//   Future<List<Map<String, dynamic>>> getRecordsForUser(int userId) async {
//     final db = await database;
//     final List<Map<String, dynamic>> records = await db.rawQuery('''
//       SELECT records.record_id, records.amount, records.budget_type,
//              categories.name AS category_name, records.date, records.note
//       FROM records
//       LEFT JOIN categories ON records.category_id = categories.category_id
//       WHERE records.account_id = ?
//     ''', [userId]);
//     return records;
//   }

//   // Optional: Method to delete a record
//   Future<int> deleteRecord(int recordId) async {
//     final db = await database;
//     return await db.delete(
//       'records',
//       where: 'record_id = ?',
//       whereArgs: [recordId],
//     );
//   }

//   // Optional: Method to update a record
//   Future<int> updateRecord(
//     int recordId, {
//     required double amount,
//     required String budgetType,
//     required int categoryId,
//     required String date,
//     required String note,
//   }) async {
//     final db = await database;
//     return await db.update(
//       'records',
//       {
//         'amount': amount,
//         'budget_type': budgetType,
//         'category_id': categoryId,
//         'date': date,
//         'note': note,
//       },
//       where: 'record_id = ?',
//       whereArgs: [recordId],
//     );
//   }
// }

import 'package:money_mind/data/categories.dart';
import 'package:money_mind/models/data_models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'database_3.db');
    return await openDatabase(
      path,
      version: 1, // Increment this if you change the schema
      onCreate: (db, version) async {
        // Create the users table
        await db.execute('''
          CREATE TABLE users (
            user_id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          )
        ''');

        // Create the categories table
        await db.execute('''
          CREATE TABLE categories (
            category_id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            icon TEXT NOT NULL,
            type INTEGER NOT NULL
          )
        ''');

        // Create the records table
        await db.execute('''
          CREATE TABLE records (
            record_id INTEGER PRIMARY KEY AUTOINCREMENT,
            account_id INTEGER,
            budget_type TEXT NOT NULL,
            category_id INTEGER,
            amount REAL NOT NULL,
            date TEXT NOT NULL,
            note TEXT,
            FOREIGN KEY (account_id) REFERENCES users(user_id),
            FOREIGN KEY (category_id) REFERENCES categories(category_id)
          )
        ''');
        await _insertPredefinedCategories(db);
      },
    );
  }

  // User-related methods
  Future<int> registerUser(String username, String password) async {
    final db = await database;
    try {
      return await db.insert(
        'users',
        {'username': username, 'password': password},
      );
    } catch (e) {
      print('Error during registration: $e');
      return -1; // Indicate failure
    }
  }

  Future<int?> loginUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result.first['user_id'] as int;
    }
    return null;
  }

  Future<void> _insertPredefinedCategories(Database db) async {
    for (var category in categories) {
      await db.insert(
        'categories',
        {
          'name': category.name,
          'icon': category.icon,
          'type': category.type.index, // Assuming CategoryType is an enum
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    final List<Map<String, dynamic>> result = await db.query('categories');
    print('DATABASE CONTENT AFTER INSERTION: $result');
  }

  Future<void> printDatabaseContent() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('categories');
    print('CURRENT DATABASE CONTENT: $result');
  }

  Future<dynamic> returnTheCategory() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('categories');
    return result;
  }

  Future<List<Category>> getIncomeCategories({CategoryType? type}) async {
    final db = await database;
    await printDatabaseContent();
    List<Map<String, dynamic>> categoryMaps;

    if (type != null) {
      // If a type is provided, filter categories by type
      categoryMaps = await db.query(
        'categories',
        where: 'type = ?',
        whereArgs: [type.index], // Use the index of the enum
      );
    } else {
      // If no type is provided, get all categories
      categoryMaps = await db.query('categories');
    }
    print('CATEGORY MAPS: $categoryMaps'); // Debug print
    return List.generate(categoryMaps.length, (i) {
      return Category(
        id: categoryMaps[i]['category_id'], // Ensure the correct key is used
        name: categoryMaps[i]['name'],
        icon: categoryMaps[i]['icon'],
        type: CategoryType
            .values[categoryMaps[i]['type']], // Convert integer to enum
      );
    });
  }

  // Future<List<Category>> getExpendCategories({Cate})

  // Record-related methods
  Future<void> insertRecord(int accountId, String budgetType, int categoryId,
      double amount, String date, String note) async {
    final db = await database;
    await db.insert(
      'records',
      {
        'account_id': accountId,
        'budget_type': budgetType,
        'category_id': categoryId,
        'amount': amount,
        'date': date,
        'note': note,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getRecordsForUser(int userId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> records = await db.rawQuery('''
      SELECT records.record_id, records.amount, records.budget_type, 
             categories.category_id AS category_id,
             categories.name AS category_name,
             categories.icon AS category_icon,
             categories.type AS category_type,
             records.date, records.note
      FROM records
      LEFT JOIN categories ON records.category_id = categories.category_id
      WHERE records.account_id = ?
    ''', [userId]);
      return records;
    } catch (e) {
      print('Error fetching records: $e');
      return []; // or handle the error as appropriate for your app
    }
  }

  // Optional: Method to delete a record
  Future<int> deleteRecord(int recordId) async {
    final db = await database;
    return await db.delete(
      'records',
      where: 'record_id = ?',
      whereArgs: [recordId],
    );
  }

  // Optional: Method to update a record
  Future<int> updateRecord(
    int recordId, {
    required double amount,
    required String budgetType,
    required int categoryId,
    required String date,
    required String note,
  }) async {
    final db = await database;
    return await db.update(
      'records',
      {
        'amount': amount,
        'budget_type': budgetType,
        'category_id': categoryId,
        'date': date,
        'note': note,
      },
      where: 'record_id = ?',
      whereArgs: [recordId],
    );
  }
}
