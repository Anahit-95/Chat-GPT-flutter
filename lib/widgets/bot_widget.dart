import 'package:chat_gpt_api/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../models/bot_model.dart';
import '../screens/audio_screen.dart';

class BotWidget extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color color;

  BotWidget({
    required this.title,
    required this.iconData,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Simple Bot':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
            break;
          case 'Audio Reader':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AudioToText()),
            );
            break;
          default:
            Navigator.of(context).pushNamed('/');
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 25,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
