import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tts/flutter_tts.dart';

part 'text_to_speech_event.dart';
part 'text_to_speech_state.dart';

class TextToSpeechBloc extends Bloc<TextToSpeechEvent, TextToSpeechState> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  int? currentMessageIndex;

  TextToSpeechBloc() : super(TextToSpeechInitial()) {
    on<TtsInitialized>(_initTts);
    on<StartSpeaking>(_onStartSpeaking);
    on<StopSpeaking>(_onStopSpeaking);
    on<DisposeTts>(_onDisposeTts);
  }

  Future<void> _initTts(
      TtsInitialized event, Emitter<TextToSpeechState> emit) async {
    emit(TextToSpeechInitial());
  }

  Future<void> initializeTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
  }

  Future<void> _onStartSpeaking(
      StartSpeaking event, Emitter<TextToSpeechState> emit) async {
    if (isSpeaking) {
      await flutterTts.stop();
      isSpeaking = false;
      emit(TextToSpeechMuted());
    }
    emit(TextToSpeechSpeaking());
    currentMessageIndex = event.messageIndex;
    isSpeaking = true;
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(event.text);
    isSpeaking = false;
    emit(TextToSpeechMuted());
  }

  Future<void> _onStopSpeaking(
      StopSpeaking event, Emitter<TextToSpeechState> emit) async {
    if (isSpeaking) {
      await flutterTts.stop();
      isSpeaking = false;
      emit(TextToSpeechMuted());
    }
  }

  @override
  Future<void> close() {
    add(StopSpeaking());
    return super.close();
  }

  FutureOr<void> _onDisposeTts(
      DisposeTts event, Emitter<TextToSpeechState> emit) async {
    await flutterTts.stop();
  }
}
