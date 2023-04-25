import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../services/api_services.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> _chatList = [];
  List<ChatModel> _audioChatList = [];
  List<ChatModel> _translatedChatList = [];

  List<ChatModel> get getChatList {
    return _chatList;
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

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith('gpt')) {
      _chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      ));
    } else {
      _chatList.addAll(await ApiService.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }
}
