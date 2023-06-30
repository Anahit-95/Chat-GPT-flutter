import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'speech_to_text_event.dart';
part 'speech_to_text_state.dart';

class SpeechToTextBloc extends Bloc<SpeechToTextEvent, SpeechToTextState> {
  final SpeechToText speechToText = SpeechToText();

  SpeechToTextBloc() : super(const SpeechToTextInitial()) {
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<PrintWords>(_onPrintWords);
  }

  FutureOr<void> _onStartListening(
      StartListening event, Emitter<SpeechToTextState> emit) async {
    try {
      if (!state.isListening) {
        emit(const ListeningStarted(''));
        await speechToText.initialize(
          onError: (error) => add(StopListening()),
          onStatus: (status) {
            print(status);
            if (status != 'listening') {
              // emit(const ListeningStopped());
              add(StopListening());
            }
          },
        );
        await speechToText.listen(
          partialResults: true,
          listenFor: const Duration(seconds: 60),
          pauseFor: const Duration(seconds: 5),
          localeId: 'en_US',
          listenMode: ListenMode.deviceDefault,
          onResult: (result) {
            print('Recognized words - ${result.recognizedWords}');
            add(PrintWords(result.recognizedWords));
          },
        );
      } else {
        speechToText.stop();
        emit(const ListeningStopped());
      }
    } catch (error) {
      emit(SpeechToTextError(error.toString()));
    }
  }

  FutureOr<void> _onStopListening(
      StopListening event, Emitter<SpeechToTextState> emit) {
    speechToText.stop();
    emit(const ListeningStopped());
  }

  void _onPrintWords(PrintWords event, Emitter<SpeechToTextState> emit) {
    emit(ListeningStarted(event.recognizedWords));
  }
}
