// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'chat_model.dart';

class ConversationModel {
  int id;
  String title;
  String type;
  List<ChatModel> messages;

  ConversationModel({
    required this.id,
    required this.title,
    required this.type,
    required this.messages,
  });

  ConversationModel copyWith({
    int? id,
    String? title,
    String? type,
    List<ChatModel>? messages,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      messages: messages ?? this.messages,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'title': title,
  //     'type': type,
  //     'messages': messages.map((x) => x.toMap()).toList(),
  //   };
  // }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      id: map['id'] as int,
      title: map['title'] as String,
      type: map['type'] as String,
      messages: List<ChatModel>.from(
        (map['messages'] as List<int>).map<ChatModel>(
          (x) => ChatModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
