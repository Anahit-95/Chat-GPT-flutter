import 'package:flutter/material.dart';

import '../constants/constants.dart';

class SendAudioBar extends StatelessWidget {
  final Future<void> Function() sendMessage;
  const SendAudioBar({
    super.key,
    required this.sendMessage,
  });

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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: Text(
                maxLines: 1,
                'Choose Audio file to read from',
                style: TextStyle(
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () async {
                await sendMessage();
              },
              child: const Text(
                'Pick File',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
