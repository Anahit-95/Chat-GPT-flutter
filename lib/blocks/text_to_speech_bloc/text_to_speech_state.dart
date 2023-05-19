part of 'text_to_speech_bloc.dart';

abstract class TextToSpeechState extends Equatable {
  const TextToSpeechState();

  @override
  List<Object> get props => [];
}

class TextToSpeechInitial extends TextToSpeechState {}

class TextToSpeechMuted extends TextToSpeechState {}

class TextToSpeechSpeaking extends TextToSpeechState {}
