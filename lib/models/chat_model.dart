// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModel {
  final int? id;
  final String msg;
  final int chatIndex;

  ChatModel({this.id, required this.msg, required this.chatIndex});

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json['id'] != null ? json['id'] as int : null,
        msg: json['msg'],
        chatIndex: json['chatIndex'],
      );

  Map<String, dynamic> toMap(int conversationId) {
    return <String, dynamic>{
      'id': id,
      'conversationId': conversationId,
      'msg': msg,
      'chatIndex': chatIndex,
    };
  }
}
