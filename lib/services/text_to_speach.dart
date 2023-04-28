import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static FlutterTts tts = FlutterTts();
  static bool isSpeaking = false;

  static initTTS() {
    tts.setLanguage("en-US");
    tts.setPitch(1.0);
  }

  static speak(String text) async {
    tts.setStartHandler(() {
      print('TTS IS STARTED');
      isSpeaking = true;
    });

    tts.setCompletionHandler(() {
      print('Completed');
      isSpeaking = false;
    });
    tts.setErrorHandler((message) {
      isSpeaking = false;
      print(message);
    });

    await tts.awaitSpeakCompletion(true);
    tts.speak(text);
  }

  static Future<void> stopSpeaking() async {
    isSpeaking = false;
    await tts.stop();
  }
}
