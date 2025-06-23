import 'package:flutter/material.dart';
import 'package:money_mind/Screen/Notification_screen.dart';
// import 'package:money_mind/Screen/graph_screen.dart';
import 'package:money_mind/Screen/setting_screen.dart';
import 'package:money_mind/pages/home_screen.dart';
import 'package:money_mind/styles/color.dart';
// import 'package:money_mind/test/graph_test.dart';
import 'package:money_mind/test/tab_container.dart';
// import 'package:money_mind/test/test_body_graph.dart';

class MainScreen extends StatefulWidget {
  final int userId;
  const MainScreen({super.key, required this.userId});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq),
            label: 'Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Limitation',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        iconSize: 24,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(userId: widget.userId),
          // MyApp(),
          MyTabScreen(userId: widget.userId),
          const NotificationScreen(),
          const SettingScreen(),
        ],
      ),
    );
  }
}
