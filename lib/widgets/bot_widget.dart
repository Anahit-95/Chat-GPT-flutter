import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocks/text_to_speech_bloc/text_to_speech_bloc.dart';
import '../blocks/chat_bloc/chat_bloc.dart';

import '../screens/chat_screen.dart';
import '../screens/image_generator_screen.dart';
import '../screens/audio_screen.dart';

import '../models/bot_model.dart';

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
                  create: (context) =>
                      ChatBloc(bot: bot, textToSpeechBloc: TextToSpeechBloc()),
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
                  create: (context) =>
                      ChatBloc(bot: bot, textToSpeechBloc: TextToSpeechBloc()),
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
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          // color: bot.color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Colors.indigo.withOpacity(.2),
              // color: bot.color.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bot.color,
                // color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                bot.iconData,
                color: Colors.white,
                // color: bot.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(bot.title, style: Theme.of(context).textTheme.titleMedium!
                // .copyWith(color: Colors.white),
                )
          ],
        ),
      ),
    );
  }
}
