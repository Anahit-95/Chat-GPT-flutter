import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../services/api_services.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> _chatList = [];
  List<ChatModel> _sarcasticChatList = [];
  List<ChatModel> _audioChatList = [];
  List<ChatModel> _translatedChatList = [];

  List<ChatModel> get getChatList {
    return _chatList;
  }

  List<ChatModel> get getSarcasticChatList {
    return _sarcasticChatList;
  }

  List<ChatModel> get getAudioChatList {
    return _audioChatList;
  }

  List<ChatModel> get getTranslatedChatList {
    return _translatedChatList;
  }

  void addUserMessage(
      {required String msg, required List<ChatModel> chatList}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  void addBotMessage({required String msg, required List<ChatModel> chatList}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 1));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers({
    required String msg,
    required String chosenModelId,
    required List<ChatModel> chatList,
    String? systemMessage,
  }) async {
    if (chosenModelId.toLowerCase().startsWith('gpt')) {
      List<Map<String, String>> messages = [];

      for (var i = 0; i < chatList.length; i++) {
        switch (chatList[i].chatIndex) {
          case 0:
            messages.add({
              'role': 'user',
              'content': chatList[i].msg,
            });
            break;
          case 1:
            messages.add({
              'role': 'assistant',
              'content': chatList[i].msg,
            });
            break;
        }
      }

      ApiService.messages = messages;

      chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
        systemMessage: systemMessage!,
      ));
    } else {
      chatList.addAll(await ApiService.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }
}
