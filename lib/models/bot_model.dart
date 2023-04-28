import 'package:flutter/material.dart';

import './chat_model.dart';

class Bot {
  final String title;
  final IconData iconData;
  final Color color;
  final List<ChatModel> chatList;
  final String? systemMessage;

  Bot({
    required this.title,
    required this.iconData,
    required this.color,
    required this.chatList,
    this.systemMessage,
  });
}
