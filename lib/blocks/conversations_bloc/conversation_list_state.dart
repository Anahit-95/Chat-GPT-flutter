// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'conversation_list_bloc.dart';

abstract class ConversationListState extends Equatable {
  const ConversationListState();

  @override
  List<Object> get props => [];
}

class ConversationListLoading extends ConversationListState {}

class ConversationCreated extends ConversationListState {}

class ConversationListLoaded extends ConversationListState {
  final List<ConversationModel> conversations;
  const ConversationListLoaded({
    required this.conversations,
  });

  @override
  List<Object> get props => [conversations];
}

class ConversationListError extends ConversationListState {
  final String message;

  const ConversationListError(this.message);

  @override
  List<Object> get props => [message];
}
