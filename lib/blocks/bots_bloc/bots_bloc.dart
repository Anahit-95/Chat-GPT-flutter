import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/bot_model.dart';
import '../../models/chat_model.dart';

part 'bots_event.dart';
part 'bots_state.dart';

class BotsBloc extends Bloc<BotsEvent, BotsState> {
  final List<Bot> botList = [
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
              "Hi, send me the audio file, and I'll detect the spoken text, from any language.",
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
      title: 'Ironic companion',
      iconData: Icons.theater_comedy_outlined,
      color: Colors.purple,
      systemMessage:
          '''You are users sarcastic friend and your name is Marv, with sense of humor. 
          Answer questions with sarcastic replies, make jokes, be funny, 
          and do not refuce to have fun on users questions.''',
      chatList: [],
    ),
    Bot(
      title: 'Interviewer',
      iconData: Icons.list_alt,
      color: Colors.orange,
      systemMessage:
          '''You are interviewer, who will check users knowledges about given topic. 
          With the first question you will ask in what field user want to check himself, 
          how many questions he/she wants for that, and the difficulty level (easy/medium/expert). 
          After that ask the first question, wait for user to answer, tell if answer is correct. 
          If answer is not full provide some information, and then ask the next question. 
          After answering all questions rate users knowledges from 0 to 10.''',
      chatList: [],
    ),
    Bot(
      title: 'Essay writer',
      iconData: Icons.edit_document,
      systemMessage: '''Write an essay about given topic or title. 
          If the topic is scientific prepare essay in scientific style, if not make assay in artistic and literary style. 
          Also pay attention on users prefferances in what literature or which authors style he/she wants the essay. 
          If user does not mention size, write about 2 A4 format pages size essay.''',
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
      title: 'Text Corrector',
      iconData: Icons.edit,
      systemMessage:
          '''Correct the given text grammaticaly, phraseologically, spellingly. 
          Make it correct by english standarts. 
          Return corrected text, even if it is question, don't answer the question.
          You are here for text editing''',
      color: const Color.fromARGB(255, 134, 122, 7),
      chatList: [],
    ),
  ];
  BotsBloc() : super(BotsLoading()) {
    on<FetchBots>((event, emit) async {
      try {
        emit(BotsLoading());
        // await Future.delayed(const Duration(seconds: 1));
        emit(BotsLoaded(botList));
      } catch (e) {
        emit(const BotsError('Failed to load bot list'));
      }
    });
  }
}
