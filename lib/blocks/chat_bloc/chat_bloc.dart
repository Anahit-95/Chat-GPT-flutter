// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import 'package:chat_gpt_api/blocks/text_to_speech_bloc/text_to_speech_bloc.dart';

import '../../models/bot_model.dart';
import '../../models/chat_model.dart';
import '../../services/api_services.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final Bot bot;
  List<ChatModel> _chatList = [];
  String _errorMessage = '';
  bool shouldAnimate = false;
  TextToSpeechBloc textToSpeechBloc;

  ChatBloc({
    required this.bot,
    required this.textToSpeechBloc,
  }) : super(ChatLoading()) {
    on<FetchChat>(_onFetchChat);
    on<AddUserMessage>(_onAddUserMessage);
    on<AddBotMessage>(_onAddBotMessage);
    on<DeleteMessage>(_onDeleteMessage);
    on<ClearChat>(_onClearChat);
    on<SendMessageAndGetAnswers>(_onSendMessageAndGetAnswers);
    on<StartAnimating>(_onStartAnimating);
    on<StopAnimating>(_onStopAnimating);
    on<SendAudioFile>(_onSendAudioFile);
    on<SendMessageGPT>(_onSendMessageGPT);
  }

  Future<void> _onFetchChat(FetchChat event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading());
      _chatList = bot.chatList;
      // await Future.delayed(const Duration(seconds: 1));
      emit(ChatLoaded(bot: bot));
    } catch (e) {
      emit(const ChatError('Failed to get chat'));
    }
  }

  void _onAddUserMessage(AddUserMessage event, Emitter<ChatState> emit) {
    try {
      _chatList.add(ChatModel(msg: event.msg, chatIndex: 0));
      emit(ChatLoaded(bot: bot.copyWith(chatList: _chatList)));
    } catch (e) {
      emit(const ChatError('Something went wrong. Failed to add message'));
    }
  }

  void _onAddBotMessage(AddBotMessage event, Emitter<ChatState> emit) async {
    try {
      emit(ChatWaiting());
      if (bot.title == 'Audio Reader') {
        await ApiService.convertSpeechToText(event.filePath).then(
          (value) => _chatList.add(ChatModel(msg: value, chatIndex: 1)),
        );
      } else {
        await ApiService.translateSpeechToEnglish(event.filePath).then(
          (value) => _chatList.add(ChatModel(msg: value, chatIndex: 1)),
        );
      }
      add(StartAnimating());
      emit(ChatLoaded(bot: bot.copyWith(chatList: _chatList)));
    } catch (e) {
      emit(ChatError('Failed to send message: $e'));
    }
  }

  FutureOr<void> _onClearChat(ClearChat event, Emitter<ChatState> emit) async {
    emit(ChatWaiting());
    _chatList.clear();

    emit(ChatLoaded(bot: bot.copyWith(chatList: _chatList)));
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
        _chatList.addAll(await ApiService.sendMessageGPT(
          message: event.msg,
          modelId: event.chosenModelId,
          systemMessage: bot.systemMessage,
        ));
        add(StartAnimating());
      } catch (e) {
        _errorMessage = e.toString();
        emit(ChatError(_errorMessage));
      }
    } else {
      try {
        _chatList.addAll(await ApiService.sendMessage(
          message: event.msg,
          modelId: event.chosenModelId,
        ));
        add(StartAnimating());
      } catch (e) {
        _errorMessage = e.toString();
        emit(ChatError(_errorMessage));
      }
    }
    emit(ChatLoaded(bot: bot.copyWith(chatList: _chatList)));
  }

  void _onDeleteMessage(DeleteMessage event, Emitter<ChatState> emit) {
    emit(ChatWaiting());
    _chatList.remove(event.msg);
    emit(ChatLoaded(bot: bot.copyWith(chatList: _chatList)));
  }

  void _onStartAnimating(StartAnimating event, Emitter<ChatState> emit) {
    shouldAnimate = true;
    emit(ChatAnimating());
  }

  void _onStopAnimating(StopAnimating event, Emitter<ChatState> emit) {
    shouldAnimate = false;
    emit(ChatLoaded(bot: bot));
  }

  FutureOr<void> _onSendAudioFile(
      SendAudioFile event, Emitter<ChatState> emit) async {
    if (state is ChatWaiting) {
      emit(const ChatError('You cant send multiple messages at a time.'));
    } else {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result != null) {
          add(AddUserMessage(msg: result.files.single.name));
          add(AddBotMessage(filePath: result.files.single.path!));
        }
      } catch (error) {
        emit(ChatError(error.toString()));
      }
    }
  }

  Future<void> _onSendMessageGPT(
      SendMessageGPT event, Emitter<ChatState> emit) async {
    if (state is ChatWaiting) {
      emit(const ChatError('You cant send multiple messages at a time.'));
      return;
    }
    if (event.msg.isEmpty) {
      emit(const ChatError('Please type a message.'));
      return;
    }
    try {
      String msg = event.msg;
      add(AddUserMessage(msg: msg));

      add(SendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: event.chosenModelId,
      ));

      await stream.firstWhere((state) {
        return state is ChatLoaded && bot.chatList.last.chatIndex == 1;
      });

      var chatMessages = bot.chatList;

      Future.delayed(const Duration(milliseconds: 0), () {
        textToSpeechBloc.add(StartSpeaking(
          messageIndex: chatMessages.length - 1,
          text: chatMessages[chatMessages.length - 1].msg,
        ));
      });
    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }
}
