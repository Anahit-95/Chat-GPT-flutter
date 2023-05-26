part of 'conversation_list_bloc.dart';

abstract class ConversationListEvent extends Equatable {
  const ConversationListEvent();

  @override
  List<Object> get props => [];
}

class FetchConversations extends ConversationListEvent {}

class CreateConversation extends ConversationListEvent {
  final String title;
  final String type;
  final List<ChatModel> chatList;

  const CreateConversation({
    required this.title,
    required this.type,
    required this.chatList,
  });

  @override
  List<Object> get props => [title, type, chatList];
}

class DeleteConversation extends ConversationListEvent {
  final int id;
  const DeleteConversation({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
