import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../services/services.dart';
import 'chat_widget.dart';

class ChatListWidget extends StatelessWidget {
  final List<ChatModel> chatList;
  final ScrollController listScrollController;
  final bool shouldAnimate;
  final void Function(int index) deleteMessage;

  const ChatListWidget({
    Key? key,
    required this.chatList,
    required this.listScrollController,
    required this.shouldAnimate,
    required this.deleteMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        controller: listScrollController,
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            key: ValueKey(chatList[index].id ?? DateTime.now()),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              await Services.confirmActionDialog(
                context: context,
                title: 'Delete message?',
                content: 'Are you sure you want to delete this message?',
                onConfirm: () => deleteMessage(index),
              );
              return null;
            },
            child: ChatWidget(
              msg: chatList[index].msg,
              chatIndex: chatList[index].chatIndex,
              messageIndex: index,
              shouldAnimate: (chatList.length - 1 == index && shouldAnimate),
            ),
          );
        },
      ),
    );
  }
}
