part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final Bot bot;

  const ChatLoaded({required this.bot});

  @override
  List<Object> get props => [bot];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}

class ChatWaiting extends ChatState {}

class ChatAnimating extends ChatState {}
