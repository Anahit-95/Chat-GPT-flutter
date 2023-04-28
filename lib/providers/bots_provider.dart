import 'package:chat_gpt_api/models/chat_model.dart';
import 'package:flutter/material.dart';

import '../models/bot_model.dart';

class BotsProvider with ChangeNotifier {
  final List<Bot> _botList = [
    Bot(
      title: 'Simple Bot',
      iconData: Icons.android,
      color: Colors.red,
      systemMessage: 'You are a helpfull assistant.',
      chatList: [],
    ),
    Bot(
      title: 'Audio Reader',
      iconData: Icons.audio_file,
      color: Colors.blue,
      chatList: [
        ChatModel(
          msg:
              "Hi, send me the audio file, and I'll detext the spoken text, regardless of the language being spoken.",
          chatIndex: 1,
        ),
      ],
    ),
    Bot(
      title: 'Audio Translater',
      iconData: Icons.translate,
      color: Colors.green,
      chatList: [
        ChatModel(
          msg:
              "Hi, send me the audio file, and I'll translate the spoken text into English.",
          chatIndex: 1,
        ),
      ],
    ),
    Bot(
      title: 'Sarcasmator',
      iconData: Icons.theater_comedy_outlined,
      color: Colors.purple,
      systemMessage:
          'You are users sarcastic friend and your name is Marv, with dark sense of humor. Answer questions with sarcastic replies, make jokes, be funny, and do not refuce to have fun on users questions.',
      chatList: [],
    ),
    Bot(
      title: 'Interviewer',
      iconData: Icons.list_alt,
      color: Colors.orange,
      systemMessage:
          'You are interviewer, who will check users knowledges about given topic. With the first question you will ask in what field user want to check himself, how many questions he/she wants for that, and the difficulty level (easy/medium/expert). After that ask the first question, wait for user to answer, tell if answer is correct, if answer is not full provide some information, and then ask the next question. After answering all questions rate users knowledges from 0 to 10.',
      chatList: [],
    ),
    Bot(
      title: 'Bot6',
      iconData: Icons.headset,
      color: Colors.teal,
      chatList: [],
    ),
    Bot(
      title: 'Image Generator',
      iconData: Icons.image_outlined,
      color: Colors.pink,
      chatList: [],
    ),
    Bot(
      title: 'Bot8',
      iconData: Icons.star,
      color: Colors.yellow,
      chatList: [],
    ),
  ];

  List<Bot> get getBotList {
    return _botList;
  }
}
