import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  static final SpeechToText _speechToText = SpeechToText();
  static bool _enabled = false;

  static bool isListening() => _speechToText.isListening;
  static bool isEnabled() => _enabled;

  static Future intialize() async {
    _enabled = await _speechToText.initialize();
  }

  static Future startListening(
    Function(SpeechRecognitionResult) onResult,
    Function(String) onStatusUpdate,
  ) async {
    if (_speechToText.isNotListening) {
      await _speechToText.listen(
        onResult: onResult,
        listenOptions: SpeechListenOptions(
          cancelOnError: true,
        ),
      );
      _speechToText.statusListener = onStatusUpdate;
    }
  }

  static Future stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }
}
