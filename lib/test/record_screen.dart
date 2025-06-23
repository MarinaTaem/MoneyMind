// import 'package:flutter/material.dart';
// import 'package:money_mind/models/record_database.dart';

// class RecordListScreen extends StatefulWidget {
//   @override
//   _RecordListScreenState createState() => _RecordListScreenState();
// }

// class _RecordListScreenState extends State<RecordListScreen> {
//   List<Map<String, dynamic>> _records = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadRecords();
//   }

//   Future<void> _loadRecords() async {
//     final records = await RecordDatabase().getRecord();
//     setState(() {
//       _records = records;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Budget Records'),
//       ),
//       body: _records.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _records.length,
//               itemBuilder: (context, index) {
//                 final record = _records[index];
//                 return ListTile(
//                   title: Text('${record['budget_type']} - ${record['amount']}'),
//                   subtitle: Text(
//                       'Category: ${record['category_name']}\nDate: ${record['date']}\nNote: ${record['note']}'),
//                 );
//               },
//             ),
//     );
//   }
// }
