part of 'conversation_bloc.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final ConversationModel conversation;

  const ConversationLoaded({required this.conversation});

  @override
  List<Object> get props => [conversation];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError(this.message);

  @override
  List<Object> get props => [message];
}

class ConversationWaiting extends ConversationState {}
