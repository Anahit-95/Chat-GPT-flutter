// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class FetchConversation extends ConversationEvent {
  final int id;

  const FetchConversation({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateConversation extends ConversationEvent {
  final int id;
  final List<ChatModel> chatList;
  const UpdateConversation({
    required this.id,
    required this.chatList,
  });
  @override
  List<Object> get props => [id, chatList];
}

class ClearMessages extends ConversationEvent {
  final int id;
  const ClearMessages({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class AddUserMessage extends ConversationEvent {
  final String msg;
  const AddUserMessage({
    required this.msg,
  });

  @override
  List<Object> get props => [msg];
}

class AddBotMessage extends ConversationEvent {
  final String msg;

  const AddBotMessage({required this.msg});

  @override
  List<Object> get props => [msg];
}

class SendMessageAndGetAnswers extends ConversationEvent {
  final String msg;
  final String chosenModelId;

  const SendMessageAndGetAnswers({
    required this.msg,
    required this.chosenModelId,
  });

  @override
  List<Object> get props => [msg, chosenModelId];
}
