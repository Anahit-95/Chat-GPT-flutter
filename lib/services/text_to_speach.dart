import 'package:flutter_tts/flutter_tts.dart';

// class TextToSpeech {
//   FlutterTts _tts = FlutterTts();
//   bool _isSpeaking = false;

//   // initTTS() {
//   //   tts.setLanguage("en-US");
//   //   tts.setPitch(1.0);
//   // }

//   Future<void> speak(String text) async {
//     if (_isSpeaking) {
//       await stopSpeaking();
//     }

//     await _tts.setLanguage("en-US");
//     await _tts.setPitch(1);
//     _tts.setStartHandler(() {
//       print('TTS IS STARTED');
//       _isSpeaking = true;
//     });

//     _tts.setCompletionHandler(() {
//       print('Completed');
//       _isSpeaking = false;
//     });
//     _tts.setErrorHandler((message) {
//       _isSpeaking = false;
//       print(message);
//     });

//     await _tts.awaitSpeakCompletion(true);
//     await _tts.speak(text);
//     _isSpeaking = true;
//   }

//   Future<void> stopSpeaking() async {
//     if (_isSpeaking) {
//       await _tts.stop();
//       _isSpeaking = false;
//     }
//   }

//   bool get isSpeaking => _isSpeaking;
// }

class TextToSpeech {
  static FlutterTts tts = FlutterTts();
  bool _isSpeaking = false;
  bool _isSpeakInProgress = false;
  late Function(bool) _onStateChanged;

  static initTTS() async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1.0);
  }

  TextToSpeech({Function(bool)? onStateChanged}) {
    _onStateChanged = onStateChanged!;
  }

  bool get isSpeaking => _isSpeaking;

  Future<void> speak(String text) async {
    if (_isSpeakInProgress) return;
    _isSpeakInProgress = true;
    await tts.awaitSpeakCompletion(true);
    tts.setStartHandler(() {
      print('TTS IS STARTED');
      _isSpeaking = true;
      if (_onStateChanged != null) {
        _onStateChanged(_isSpeaking);
      }
    });
    tts.setCompletionHandler(() {
      print('Completed');
      _isSpeaking = false;
      _isSpeakInProgress = false;
      if (_onStateChanged != null) {
        _onStateChanged(_isSpeaking);
      }
    });
    tts.setErrorHandler((message) {
      _isSpeaking = false;
      _isSpeakInProgress = false;
      if (_onStateChanged != null) {
        _onStateChanged(_isSpeaking);
      }
      print(message);
    });
    await tts.speak(text);
  }

  Future<void> stopSpeaking() async {
    _isSpeaking = false;
    if (_onStateChanged != null) {
      _onStateChanged(_isSpeaking);
    }
    await tts.stop();
  }
}
