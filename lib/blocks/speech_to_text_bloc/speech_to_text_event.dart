part of 'speech_to_text_bloc.dart';

abstract class SpeechToTextEvent extends Equatable {
  const SpeechToTextEvent();

  @override
  List<Object> get props => [];
}

class StartListening extends SpeechToTextEvent {}

class StopListening extends SpeechToTextEvent {}

class PrintWords extends SpeechToTextEvent {
  final String recognizedWords;

  const PrintWords(this.recognizedWords);

  @override
  List<Object> get props => [recognizedWords];
}
