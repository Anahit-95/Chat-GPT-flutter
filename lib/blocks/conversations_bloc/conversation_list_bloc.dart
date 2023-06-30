import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_gpt_api/services/db_services.dart';
import 'package:equatable/equatable.dart';

import '../../models/chat_model.dart';
import '../../models/conversation_model.dart';

part 'conversation_list_event.dart';
part 'conversation_list_state.dart';

class ConversationListBloc
    extends Bloc<ConversationListEvent, ConversationListState> {
  List<ConversationModel> conversations = [];
  final DatabaseHelper _dbHelper;

  ConversationListBloc({required DatabaseHelper dbHelper})
      : _dbHelper = dbHelper,
        super(ConversationListLoading()) {
    on<FetchConversations>(_onFetchConversations);
    on<CreateConversation>(_onCreateConversation);
    on<DeleteConversation>(_onDeleteConversation);
  }

  Future<void> _onFetchConversations(
      FetchConversations event, Emitter<ConversationListState> emit) async {
    emit(ConversationListLoading());
    try {
      var fetchedConversations = await _dbHelper.getConversationList();
      conversations = fetchedConversations.reversed.toList();
      emit(ConversationListLoaded(conversations: conversations));
    } catch (error) {
      emit(ConversationListError('Failed to load conversations: $error'));
    }
  }

  Future<void> _onCreateConversation(
      CreateConversation event, Emitter<ConversationListState> emit) async {
    try {
      if (event.title.isEmpty) {
        emit(const ConversationListError("Please enter conversation's title."));
        return;
      }
      emit(ConversationListLoading());
      final conversationId = await _dbHelper.createConversation(
        event.title,
        event.type,
      );
      await _dbHelper.createMessageList(
        conversationId,
        event.chatList,
      );
      emit(ConversationCreated());
      print('message from bloc - ${state.runtimeType}');
      ConversationModel conversation = ConversationModel(
        id: conversationId,
        title: event.title,
        type: event.type,
        messages: [],
      );
      conversations.insert(0, conversation);
      emit(ConversationListLoaded(conversations: conversations));
      print('message from bloc - ${state.runtimeType}');
    } catch (error) {
      emit(ConversationListError('Something went wrong: $error'));
    }
  }

  Future<void> _onDeleteConversation(
      DeleteConversation event, Emitter<ConversationListState> emit) async {
    emit(ConversationListLoading());
    try {
      await _dbHelper.deleteConversation(event.id);
      conversations.removeWhere((conversation) => conversation.id == event.id);
      emit(ConversationListLoaded(conversations: conversations));
    } catch (error) {
      emit(ConversationListError('Something went wrong: $error'));
    }
  }
}
