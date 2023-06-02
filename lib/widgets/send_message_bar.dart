import 'package:flutter/material.dart';

import '../constants/constants.dart';

class SendMessageBar extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Future<void> Function() micListening;
  final Future<void> Function() sendMessage;

  const SendMessageBar({
    Key? key,
    required this.textEditingController,
    required this.focusNode,
    required this.micListening,
    required this.sendMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: focusNode,
                style: const TextStyle(
                  color: Colors.white,
                ),
                controller: textEditingController,
                onSubmitted: (value) async {
                  await sendMessage();
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'How can I help you?',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await micListening();
                  },
                  icon: const Icon(
                    Icons.mic,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await sendMessage();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
