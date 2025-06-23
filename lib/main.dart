import 'package:flutter/material.dart';
// import 'package:money_mind/Screen/calculator_screen.dart';
// import 'package:money_mind/Screen/add_income.dart';
// import 'package:money_mind/database.dart';
import 'package:money_mind/Screen/flash_screen.dart';
// import 'package:money_mind/pages/display_income_screen.dart';
// import 'package:money_mind/pages/home_screen.dart';
// import 'package:money_mind/pages/home_screen_all.dart';
// import 'package:money_mind/Screen/sign_in_screen.dart';
// import 'package:money_mind/Screen/sign_up_screen.dart';
// import 'package:money_mind/test/catgories.dart';
// import 'package:money_mind/test/record_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlashScreen(),
    );
  }
}
