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
    return Material(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: Text(
                maxLines: 1,
                'Choose Audio file to read from',
                style: TextStyle(
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: scaffoldBackgroundColor,
              ),
              onPressed: () async {
                await sendMessage();
              },
              child: const Text(
                ' Pick File ',
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
