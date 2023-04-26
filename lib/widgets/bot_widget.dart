import 'package:chat_gpt_api/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bot_model.dart';
import '../providers/chats_provider.dart';
import '../screens/audio_screen.dart';

class BotWidget extends StatelessWidget {
  final Bot bot;

  const BotWidget({
    super.key,
    required this.bot,
  });

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return GestureDetector(
      onTap: () {
        switch (bot.title) {
          case 'Simple Bot':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  bot: bot,
                  chatList: chatProvider.getChatList,
                ),
              ),
            );
            break;
          case 'Sarcastic Bot':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  bot: bot,
                  chatList: chatProvider.getSarcasticChatList,
                ),
              ),
            );
            break;
          case 'Audio Reader':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioToText(
                  bot: bot,
                  chatList: chatProvider.getAudioChatList,
                ),
              ),
            );
            break;
          case 'Audio Translater':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AudioToText(
                        bot: bot,
                        chatList: chatProvider.getTranslatedChatList,
                      )),
            );
            break;
          default:
            Navigator.of(context).pushReplacementNamed('/');
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: bot.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              bot.iconData,
              size: 25,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              bot.title,
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
