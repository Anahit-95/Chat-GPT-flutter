import 'package:flutter/material.dart';

class Bot {
  final String title;
  final IconData iconData;
  final Color color;
  String? systemMessage;

  Bot({
    required this.title,
    required this.iconData,
    required this.color,
    this.systemMessage,
  });
}
