// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class FetchConversation extends ConversationEvent {}

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

class AddUserMessage extends ConversationEvent {
  final String msg;
  const AddUserMessage({
    required this.msg,
  });

  @override
  List<Object> get props => [msg];
}

class AddBotMessage extends ConversationEvent {
  final String filePath;

  const AddBotMessage({required this.filePath});

  @override
  List<Object> get props => [filePath];
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

class DeleteMessage extends ConversationEvent {
  final ChatModel msg;
  const DeleteMessage({
    required this.msg,
  });

  @override
  List<Object> get props => [msg];
}

class ClearMessages extends ConversationEvent {}

class UpdateMessageList extends ConversationEvent {}
