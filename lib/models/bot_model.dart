// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import './chat_model.dart';

class Bot extends Equatable {
  final String title;
  final IconData iconData;
  final Color color;
  List<ChatModel> chatList;
  final String? systemMessage;

  Bot({
    required this.title,
    required this.iconData,
    required this.color,
    required this.chatList,
    this.systemMessage,
  });

  Bot copyWith({
    String? title,
    IconData? iconData,
    Color? color,
    List<ChatModel>? chatList,
    String? systemMessage,
  }) {
    return Bot(
      title: title ?? this.title,
      iconData: iconData ?? this.iconData,
      color: color ?? this.color,
      chatList: chatList ?? this.chatList,
      systemMessage: systemMessage ?? this.systemMessage,
    );
  }

  @override
  List<Object?> get props => [
        title,
        chatList,
        systemMessage,
        iconData,
        color,
      ];
}
