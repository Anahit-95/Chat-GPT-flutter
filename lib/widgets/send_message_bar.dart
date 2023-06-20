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
    return Container(
      // color: cardColor,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            color: Colors.indigo.withOpacity(.2),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: textEditingController,
                onSubmitted: (value) async {
                  await sendMessage();
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.black.withOpacity(.2),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: btnColor.withOpacity(.8),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  hintText: 'How can I help you?',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 4),
                InkWell(
                  onTap: () async {
                    await micListening();
                  },
                  child: Icon(
                    Icons.mic_none_outlined,
                    size: 25,
                    color: Theme.of(context).primaryColor.withOpacity(.6),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    await sendMessage();
                  },
                  child: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor.withOpacity(.8),
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
