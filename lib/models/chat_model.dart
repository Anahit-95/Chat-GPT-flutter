import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final int? id;
  final String msg;
  final int chatIndex;

  const ChatModel({
    this.id,
    required this.msg,
    required this.chatIndex,
  });

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

  ChatModel copyWith({
    int? id,
    String? msg,
    int? chatIndex,
  }) {
    return ChatModel(
      id: id ?? this.id,
      msg: msg ?? this.msg,
      chatIndex: chatIndex ?? this.chatIndex,
    );
  }

  @override
  List<Object?> get props => [id, msg, chatIndex];
}
