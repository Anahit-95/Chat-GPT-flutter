import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static FlutterTts tts = FlutterTts();

  static initTTS() {
    tts.setLanguage("en-US");
    tts.setPitch(1.0);
  }

  static speak(String text) async {
    tts.setStartHandler(() {
      print('TTS IS STARTED');
    });

    tts.setCompletionHandler(() {
      print('Completed');
    });
    tts.setErrorHandler((message) {
      print(message);
    });

    await tts.awaitSpeakCompletion(true);
    tts.speak(text);
  }
}
