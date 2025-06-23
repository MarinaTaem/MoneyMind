import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:money_mind/styles/color.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  String _result = '';

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '0';
        _result = '0';
      } else if (value == '=') {
        _calculateResult();
      } else {
        _input += value;
      }

      _result;
    });
  }

  void _calculateResult() {
    try {
      String expression = _input.replaceAll('x', '*');
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      _result = eval.toString();
    } catch (e) {
      _result = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: const Text("Calculator"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Container(
            color: AppColors.tertiaryColor,
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _input,
                  style: const TextStyle(fontSize: 28, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Text(
                  _result,
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: const EdgeInsets.all(10),
              children: [
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('/'),
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('x'),
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('-'),
                _buildButton('C'),
                _buildButton('0'),
                _buildButton('='),
                _buildButton('+'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () => _buttonPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
