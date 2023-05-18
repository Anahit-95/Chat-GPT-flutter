part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class FetchChat extends ChatEvent {}

class AddUserMessage extends ChatEvent {
  final String msg;

  const AddUserMessage({required this.msg});

  @override
  List<Object> get props => [msg];
}

class AddBotMessage extends ChatEvent {
  final String msg;

  const AddBotMessage({required this.msg});

  @override
  List<Object> get props => [msg];
}

class ClearChat extends ChatEvent {}

class SendMessageAndGetAnswers extends ChatEvent {
  final String msg;
  final String chosenModelId;

  const SendMessageAndGetAnswers(
      {required this.msg, required this.chosenModelId});

  @override
  List<Object> get props => [msg, chosenModelId];
}
