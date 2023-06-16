// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/chat_model.dart';
import '../../models/conversation_model.dart';
import '../../services/api_services.dart';
import '../../services/db_services.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ConversationModel conversation;
  final String? systemMessage;
  List<ChatModel> _messages = [];
  final DatabaseHelper _dbHelper;

  ConversationBloc({
    required DatabaseHelper dbHelper,
    required this.conversation,
    required this.systemMessage,
  })  : _dbHelper = dbHelper,
        super(ConversationLoading()) {
    on<FetchConversation>(_onFetchConversation);
    on<ClearMessages>(_onClearMessages);
    on<AddUserMessage>(_onAddUserMessage);
    on<AddBotMessage>(_onAddBotMessage);
    on<SendMessageAndGetAnswers>(_onSendMessageAndGetAnswers);
    on<DeleteMessage>(_onDeleteMessages);
    on<UpdateMessageList>(_onUpdateMessageList);
  }

  FutureOr<void> _onFetchConversation(
      FetchConversation event, Emitter<ConversationState> emit) async {
    try {
      emit(ConversationLoading());
      if (conversation.messages.isEmpty) {
        _messages = await _dbHelper.getMessagesByConversation(conversation.id);
        conversation.messages = _messages;
      } else {
        _messages = conversation.messages;
      }
      emit(ConversationLoaded(
        conversation: conversation,
      ));
    } catch (e) {
      emit(ConversationError('Failed to get messages: $e'));
    }
  }

  FutureOr<void> _onAddUserMessage(
      AddUserMessage event, Emitter<ConversationState> emit) async {
    try {
      int id = await _dbHelper.createMessage(
        conversation.id,
        ChatModel(msg: event.msg, chatIndex: 0),
      );
      ChatModel chat = ChatModel(id: id, msg: event.msg, chatIndex: 0);
      _messages.add(chat);
      emit(ConversationLoaded(
        conversation: conversation.copyWith(messages: _messages),
      ));
      emit(ConversationWaiting());
    } catch (e) {
      emit(ConversationError('Failed to load message: $e'));
    }

    // _messages.add(ChatModel(msg: event.msg, chatIndex: 0));
    // emit(ConversationLoaded(
    //   conversation: conversation.copyWith(messages: _messages),
    // ));
  }

  // FutureOr<void> _onAddBotMessage(
  //     AddBotMessage event, Emitter<ConversationState> emit) async {
  //   emit(ConversationWaiting());
  //   if (conversation.type == 'Audio Reader') {
  //     await ApiService.convertSpeechToText(event.filePath).then(
  //       (value) => _messages.add(ChatModel(msg: value, chatIndex: 1)),
  //     );
  //   } else {
  //     await ApiService.translateSpeechToEnglish(event.filePath).then(
  //       (value) => _messages.add(ChatModel(msg: value, chatIndex: 1)),
  //     );
  //   }
  //   emit(ConversationAnimating());
  //   emit(ConversationLoaded(
  //     conversation: conversation.copyWith(messages: _messages),
  //   ));
  // }

  FutureOr<void> _onAddBotMessage(
      AddBotMessage event, Emitter<ConversationState> emit) async {
    emit(ConversationWaiting());
    String message = '';
    try {
      if (conversation.type == 'Audio Reader') {
        await ApiService.convertSpeechToText(event.filePath).then(
          (value) => message = value,
        );
      } else {
        await ApiService.translateSpeechToEnglish(event.filePath).then(
          (value) => message = value,
        );
      }
    } catch (e) {
      emit(ConversationError('Failed to send the file: $e'));
      return;
    }
    try {
      int id = await _dbHelper.createMessage(
          conversation.id, ChatModel(msg: message, chatIndex: 1));
      ChatModel chat = ChatModel(id: id, msg: message, chatIndex: 1);
      _messages.add(chat);
      emit(ConversationAnimating());
      emit(ConversationLoaded(
        conversation: conversation.copyWith(messages: _messages),
      ));
    } catch (e) {
      emit(ConversationError('Failed to lead message: $e'));
    }
  }

  FutureOr<void> _onClearMessages(
      ClearMessages event, Emitter<ConversationState> emit) async {
    emit(ConversationWaiting());
    try {
      await _dbHelper.deleteMessages(conversation.id);
      _messages.clear();
      emit(ConversationLoaded(
        conversation: conversation.copyWith(messages: _messages),
      ));
    } catch (e) {
      emit(ConversationError('Failed to clear messages from database: $e'));
    }
  }

  Future<void> _onSendMessageAndGetAnswers(
      SendMessageAndGetAnswers event, Emitter<ConversationState> emit) async {
    if (event.chosenModelId.toLowerCase().startsWith('gpt')) {
      emit(ConversationWaiting());
      List<Map<String, String>> messages = [];

      for (var i = 0; i < conversation.messages.length; i++) {
        switch (conversation.messages[i].chatIndex) {
          case 0:
            messages.add({
              'role': 'user',
              'content': conversation.messages[i].msg,
            });
            break;
          case 1:
            messages.add({
              'role': 'assistant',
              'content': conversation.messages[i].msg,
            });
            break;
        }
      }

      ApiService.messages = messages;

      try {
        // _messages.addAll(await ApiService.sendMessageGPT(
        //   message: event.msg,
        //   modelId: event.chosenModelId,
        //   systemMessage: systemMessage,
        // ));

        List<ChatModel> chatList = await ApiService.sendMessageGPT(
          message: event.msg,
          modelId: event.chosenModelId,
          systemMessage: systemMessage,
        );
        for (var chat in chatList) {
          int id = await _dbHelper.createMessage(conversation.id, chat);
          chat = chat.copyWith(id: id);
          _messages.add(chat);
        }
        emit(ConversationAnimating());
      } catch (e) {
        emit(ConversationError('Failed to sent the message: $e'));
      }
    } else {
      try {
        // _messages.addAll(await ApiService.sendMessage(
        //   message: event.msg,
        //   modelId: event.chosenModelId,
        // ));

        List<ChatModel> chatList = await ApiService.sendMessage(
          message: event.msg,
          modelId: event.chosenModelId,
        );
        for (var chat in chatList) {
          int id = await _dbHelper.createMessage(conversation.id, chat);
          chat = chat.copyWith(id: id);
          _messages.add(chat);
        }
        emit(ConversationAnimating());
      } catch (e) {
        emit(ConversationError('Failed to sent the message: $e'));
      }
    }
    emit(ConversationLoaded(
      conversation: conversation.copyWith(messages: _messages),
    ));
  }

  Future<void> _onDeleteMessages(
      DeleteMessage event, Emitter<ConversationState> emit) async {
    try {
      emit(ConversationWaiting());
      print('event started');
      if (event.msg.id != null) {
        await _dbHelper.deleteMessage(conversation.id, event.msg.id!);
        print('message deleted from database');
      }
      _messages.remove(event.msg);
      print('message deleted from list');
      emit(ConversationLoaded(
        conversation: conversation.copyWith(messages: _messages),
      ));
      print('event completed');
    } catch (e) {
      emit(ConversationError('Failed to delete message: $e'));
    }
  }

  Future<void> _onUpdateMessageList(
      UpdateMessageList event, Emitter<ConversationState> emit) async {
    try {
      emit(ConversationWaiting());
      await _dbHelper.updateMessageList(conversation.id, conversation.messages);
      _messages = await _dbHelper.getMessagesByConversation(conversation.id);
      conversation.messages = _messages;
      emit(ConversationLoaded(
        conversation: conversation,
      ));
    } catch (e) {
      emit(ConversationError('Failed to save messages: $e'));
    }
  }
}
