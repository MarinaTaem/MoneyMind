import 'package:flutter/material.dart';
import 'package:money_mind/Screen/graph/daily_graph_screen.dart';
import 'package:money_mind/Screen/graph/monthly_graph_screen.dart';
import 'package:money_mind/Screen/graph/weekly_graph_screen.dart';
import 'package:money_mind/Screen/graph/yearly_graph_screen.dart';
import 'package:tab_container/tab_container.dart';

class MyTabScreen extends StatelessWidget {
  final int userId;
  MyTabScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: TabContainer(
            color: Colors.blue[100],
            tabs: [
              Text('Daily'),
              Text('Weekly'),
              Text('Monthly'),
              Text('Yearly'),
            ],
            children: [
              Center(child: DailyGraphScreen(userId: userId)),
              Center(child: WeeklyGraphScreen(userId: userId)),
              Center(child: MonthlyGraphScreen(userId: userId)),
              Center(child: YearlyGraphScreen(userId: userId)),
            ],
          ),
        ),
      ),
    );
  }
}
