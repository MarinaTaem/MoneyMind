// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:money_mind/Screen/graph/daily_graph_screen.dart';
// import 'package:money_mind/Screen/graph/monthly_graph_screen.dart';
// import 'package:money_mind/Screen/graph/weekly_graph_screen.dart';
// import 'package:money_mind/Screen/graph/yearly_graph_screen.dart';
// import 'package:path/path.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Bar Chart Example'),
//           bottom: TabBar(
//             controller: _tabController,
//             tabs: [
//               Tab(text: 'Dialy'),
//               Tab(text: 'Weekly'),
//               Tab(text: 'Monthly'),
//               Tab(text: 'Yearly'),
//             ],
//           ),
//         ),
//         // body: Padding(
//         //   padding: const EdgeInsets.all(16.0),
//         //   child: Column(
//         //     children: [
//         //       Expanded(
//         //         child: BarChartSample(),
//         //       )
//         //     ],
//         //   ),
//         // ),
//         body: TabBarView(
//           controller: _tabController,
//           children: [
//             DailyGraphScreen(),
//             WeeklyGraphScreen(),
//             MonthlyGraphScreen(),
//             YearlyGraphScreen(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BarChartSample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         alignment: BarChartAlignment.values[50],
//         barGroups: [
//           BarChartGroupData(
//             x: 0,
//             barRods: [
//               BarChartRodData(
//                 toY: 10,
//                 color: Colors.blue,
//                 width: 20,
//               ),
//               BarChartRodData(
//                 toY: 17,
//                 color: Colors.green,
//                 width: 20,
//               ),
//             ],
//           ),
//           BarChartGroupData(
//             x: 1,
//             barRods: [
//               BarChartRodData(
//                 toY: 10,
//                 color: Colors.blue,
//                 width: 20,
//               ),
//               BarChartRodData(
//                 toY: 2,
//                 color: Colors.green,
//                 width: 20,
//               ),
//             ],
//           ),
//           BarChartGroupData(
//             x: 1,
//             barRods: [
//               BarChartRodData(
//                 toY: 10,
//                 color: Colors.blue,
//                 width: 20,
//               ),
//               BarChartRodData(
//                 toY: 2,
//                 color: Colors.green,
//                 width: 20,
//               ),
//             ],
//           ),
//           BarChartGroupData(
//             x: 1,
//             barRods: [
//               BarChartRodData(
//                 toY: 10,
//                 color: Colors.blue,
//                 width: 20,
//               ),
//               BarChartRodData(
//                 toY: 2,
//                 color: Colors.green,
//                 width: 20,
//               ),
//             ],
//           ),
//         ],
//         groupsSpace: 20,
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(
//             axisNameWidget: const Text('thi azis'),
//             axisNameSize: 30,
//             sideTitles:
//                 SideTitles(showTitles: true, reservedSize: 44, interval: null),
//           ),
//           bottomTitles: const AxisTitles(
//             axisNameWidget: Text('x axis'),
//             axisNameSize: 30,
//             sideTitles: SideTitles(showTitles: true),
//           ),
//         ),
//       ),
//     );
//   }
// }
