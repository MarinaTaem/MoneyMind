import 'package:flutter/material.dart';

class textHeader {
  late String content;

  textHeader({
    required this.content,
  });

  Widget build() {
    return Text(
      content,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Colors.black,
      ),
    );
  }
}

class TextContent {
  late String content;

  TextContent({
    required this.content,
  });

  Widget build() {
    return Text(
      content,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }
}
