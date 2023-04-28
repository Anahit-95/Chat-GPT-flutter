import 'package:flutter/material.dart';

import '../models/bot_model.dart';
import '../models/chat_model.dart';
import '../services/api_services.dart';

class ChatProvider with ChangeNotifier {
  Bot bot;

  ChatProvider({required this.bot});

  void addUserMessage({required String msg}) {
    bot.chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  void addBotMessage({required String msg}) {
    bot.chatList.add(ChatModel(msg: msg, chatIndex: 1));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers({
    required String msg,
    required String chosenModelId,
    String? systemMessage,
  }) async {
    if (chosenModelId.toLowerCase().startsWith('gpt')) {
      List<Map<String, String>> messages = [];

      for (var i = 0; i < bot.chatList.length; i++) {
        switch (bot.chatList[i].chatIndex) {
          case 0:
            messages.add({
              'role': 'user',
              'content': bot.chatList[i].msg,
            });
            break;
          case 1:
            messages.add({
              'role': 'assistant',
              'content': bot.chatList[i].msg,
            });
            break;
        }
      }

      ApiService.messages = messages;

      bot.chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
        systemMessage: systemMessage!,
      ));
    } else {
      bot.chatList.addAll(await ApiService.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }
}
