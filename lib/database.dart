// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseLogin {
//   static final DatabaseLogin _instance = DatabaseLogin._internal();
//   static Database? _database;

//   factory DatabaseLogin() {
//     return _instance;
//   }

//   DatabaseLogin._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'account.db');

//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE users (
//             id_account INTEGER PRIMARY KEY AUTOINCREMENT,
//             username TEXT,
//             password TEXT
//           )
//         ''');
//       },
//     );
//   }

//   Future<int> registerUser(String username, String password) async {
//     final db = await database;

//     try {
//       return await db.insert(
//         'account',
//         {'username': username, 'password': password},
//       );
//     } catch (e) {
//       return -1; // Indicate failure (e.g., duplicate email)
//     }
//   }

//   Future<Map<String, dynamic>?> loginUser(
//       String username, String password) async {
//     final db = await database;

//     final List<Map<String, dynamic>> result = await db.query(
//       'account',
//       where: 'username = ? AND password = ?',
//       whereArgs: [username, password],
//     );

//     if (result.isNotEmpty) {
//       return result.first; // Login successful
//     } else {
//       return null; // Login failed
//     }
//   }
// }
