import 'package:chat_gpt_api/screens/chat_screen.dart';
import 'package:chat_gpt_api/screens/image_generator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';

import '../blocks/chat_bloc/chat_bloc.dart';
import '../models/bot_model.dart';
// import '../providers/chats_provider.dart';
import '../screens/audio_screen.dart';

class BotWidget extends StatelessWidget {
  final Bot bot;

  const BotWidget({
    super.key,
    required this.bot,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (bot.title) {
          case 'Simple Bot':
          case 'Ironic companion':
          case 'Interviewer':
          case 'Essay writer':
          case 'Text Corrector':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ChatBloc(bot: bot),
                  child: const ChatScreen(),
                ),
              ),
            );
            break;
          case 'Audio Reader':
          case 'Audio Translater':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ChatBloc(bot: bot),
                  child: const AudioToText(),
                ),
              ),
            );
            break;
          case 'Image Generator':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ImageGeneratorScreen(),
              ),
            );
            break;
          default:
            Navigator.of(context).pushReplacementNamed('/');
        }
      },
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bot.color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                bot.iconData,
                size: 25,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  bot.title,
                  softWrap: true,
                  // textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
