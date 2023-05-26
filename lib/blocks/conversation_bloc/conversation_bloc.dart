import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/chat_model.dart';
import '../../models/conversation_model.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc() : super(ConversationLoading()) {
    on<FetchConversation>(_onFetchConversation);
    on<ClearMessages>(_onClearMessages);
    on<AddUserMessage>(_onAddUserMessage);
    on<AddBotMessage>(_onAddBotMessage);
    on<SendMessageAndGetAnswers>(_onSendMessageAndGetAnswers);
  }

  FutureOr<void> _onFetchConversation(
      FetchConversation event, Emitter<ConversationState> emit) {}

  FutureOr<void> _onClearMessages(
      ClearMessages event, Emitter<ConversationState> emit) {}

  FutureOr<void> _onAddUserMessage(
      AddUserMessage event, Emitter<ConversationState> emit) {}

  FutureOr<void> _onAddBotMessage(
      AddBotMessage event, Emitter<ConversationState> emit) {}

  FutureOr<void> _onSendMessageAndGetAnswers(
      SendMessageAndGetAnswers event, Emitter<ConversationState> emit) {}
}
