import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/bot_model.dart';
import '../../models/chat_model.dart';
import '../../services/api_services.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final Bot bot;
  List<ChatModel> chatList = [];
  String errorMessage = '';

  ChatBloc({required this.bot}) : super(ChatLoading()) {
    on<FetchChat>(_onFetchChat);
    on<AddUserMessage>(_onAddUserMessage);
    on<AddBotMessage>(_onAddBotMessage);
    on<ClearChat>(_onClearChat);
    on<SendMessageAndGetAnswers>(_onSendMessageAndGetAnswers);
  }

  Future<void> _onFetchChat(FetchChat event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading());
      await Future.delayed(const Duration(seconds: 1));
      chatList = bot.chatList;
      emit(ChatLoaded(bot: bot));
    } catch (e) {
      emit(const ChatError('Failed to get chat'));
    }
  }

  void _onAddUserMessage(AddUserMessage event, Emitter<ChatState> emit) {
    // chatList = bot.chatList;
    chatList.add(ChatModel(msg: event.msg, chatIndex: 0));
    emit(ChatLoaded(bot: bot.copyWith(chatList: chatList)));
  }

  void _onAddBotMessage(AddBotMessage event, Emitter<ChatState> emit) {
    chatList.add(ChatModel(msg: event.msg, chatIndex: 1));
    emit(ChatLoaded(bot: bot.copyWith(chatList: chatList)));
  }

  FutureOr<void> _onClearChat(ClearChat event, Emitter<ChatState> emit) {
    chatList.clear();
    emit(ChatLoaded(bot: bot.copyWith(chatList: chatList)));
  }

  Future<void> _onSendMessageAndGetAnswers(
      SendMessageAndGetAnswers event, Emitter<ChatState> emit) async {
    if (event.chosenModelId.toLowerCase().startsWith('gpt')) {
      emit(ChatWaiting());
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
      try {
        chatList.addAll(await ApiService.sendMessageGPT(
          message: event.msg,
          modelId: event.chosenModelId,
          systemMessage: bot.systemMessage,
        ));
      } catch (e) {
        errorMessage = e.toString();
        emit(ChatError(errorMessage));
      }
    } else {
      try {
        chatList.addAll(await ApiService.sendMessage(
          message: event.msg,
          modelId: event.chosenModelId,
        ));
      } catch (e) {
        errorMessage = e.toString();
        emit(ChatError(errorMessage));
      }
    }
    emit(ChatLoaded(bot: bot.copyWith(chatList: chatList)));
  }
}