// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModel {
  final String msg;
  final int chatIndex;

  ChatModel({required this.msg, required this.chatIndex});

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        msg: json['msg'],
        chatIndex: json['chatIndex'],
      );

  Map<String, dynamic> toMap(int id) {
    return <String, dynamic>{
      'conversationId': id,
      'msg': msg,
      'chatIndex': chatIndex,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      msg: map['msg'] as String,
      chatIndex: map['chatIndex'] as int,
    );
  }

  // String toJson() => json.encode(toMap());
}
