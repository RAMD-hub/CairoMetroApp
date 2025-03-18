import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  AudioService() {
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      await _player.setAsset("assets/media/welcome_to_metro.mp3");
    } catch (e) {
      print("Error in loadAudio $e");
    }
  }

  Future<void> playSound() async {
    try {
      await _player.play();
    } catch (e) {
      print("Error in play audio $e");
    }
  }

  void stopSound() {
    _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}
