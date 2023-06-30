// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final String filePath;

  const AddBotMessage({required this.filePath});

  @override
  List<Object> get props => [filePath];
}

class SendAudioFile extends ChatEvent {}

class DeleteMessage extends ChatEvent {
  final ChatModel msg;
  const DeleteMessage({
    required this.msg,
  });

  @override
  List<Object> get props => [msg];
}

class ClearChat extends ChatEvent {}

class SendMessageAndGetAnswers extends ChatEvent {
  final String msg;
  final String chosenModelId;

  const SendMessageAndGetAnswers({
    required this.msg,
    required this.chosenModelId,
  });

  @override
  List<Object> get props => [msg, chosenModelId];
}

class SendMessageGPT extends ChatEvent {
  final String msg;
  final String chosenModelId;

  const SendMessageGPT({
    required this.msg,
    required this.chosenModelId,
  });

  @override
  List<Object> get props => [msg, chosenModelId];
}

class StartAnimating extends ChatEvent {}

class StopAnimating extends ChatEvent {}
