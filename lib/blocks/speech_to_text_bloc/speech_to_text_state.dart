// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'speech_to_text_bloc.dart';

abstract class SpeechToTextState extends Equatable {
  final bool isListening;
  const SpeechToTextState(this.isListening);

  @override
  List<Object> get props => [];
}

class SpeechToTextInitial extends SpeechToTextState {
  const SpeechToTextInitial() : super(false);
}

class SpeechToTextError extends SpeechToTextState {
  final String error;

  const SpeechToTextError(this.error) : super(false);

  @override
  List<Object> get props => [error];
}

class ListeningStarted extends SpeechToTextState {
  final String recognizedWords;

  const ListeningStarted(
    this.recognizedWords,
  ) : super(true);

  @override
  List<Object> get props => [recognizedWords];
}

class ListeningStopped extends SpeechToTextState {
  const ListeningStopped() : super(false);
}
