part of 'text_to_speech_bloc.dart';

abstract class TextToSpeechEvent extends Equatable {
  const TextToSpeechEvent();

  @override
  List<Object> get props => [];
}

class TtsInitialized extends TextToSpeechEvent {}

class StartSpeaking extends TextToSpeechEvent {
  final String text;
  final int messageIndex;

  const StartSpeaking({required this.messageIndex, required this.text});

  @override
  List<Object> get props => [text];
}

class StopSpeaking extends TextToSpeechEvent {}

class DisposeTts extends TextToSpeechEvent {}
