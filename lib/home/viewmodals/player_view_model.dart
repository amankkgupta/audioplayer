import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/audio_handler.dart';

class PlayerVm extends ChangeNotifier {
  static const String _lastPlayedTitleKey = 'last_played_title';

  PlayerVm({required AppAudioHandler audioHandler}) : _audioHandler = audioHandler {
    _audioHandler.playbackState.listen((_) => notifyListeners());
    _audioHandler.mediaItem.listen((item) {
      if (item != null && item.title.isNotEmpty) {
        _lastPlayedTitle = item.title;
        _persistLastPlayedTitle(item.title);
      }
      notifyListeners();
    });
    _audioHandler.queue.listen((_) => notifyListeners());
    _audioHandler.player.positionStream.listen((_) => notifyListeners());
    _audioHandler.player.durationStream.listen((_) => notifyListeners());
    _audioHandler.player.currentIndexStream.listen((_) => notifyListeners());
    _loadLastPlayedTitle();
  }

  final AppAudioHandler _audioHandler;
  String _lastPlayedTitle = '';

  String get currentTitle => _audioHandler.mediaItem.value?.title ?? '';
  String get lastPlayedTitle => currentTitle.isNotEmpty ? currentTitle : _lastPlayedTitle;
  String get skandhName => _audioHandler.mediaItem.value?.artist ?? '';
  int get currentIndex => _audioHandler.currentIndex;
  List<String> get chapterAudioUrls => _audioHandler.queue.value.map((item) => item.id).toList();
  Duration get position => _audioHandler.player.position;
  Duration get duration => _audioHandler.player.duration ?? Duration.zero;
  bool get isPlaying => _audioHandler.playbackState.value.playing;
  bool get isLoading =>
      _audioHandler.player.processingState == ProcessingState.loading ||
      _audioHandler.player.processingState == ProcessingState.buffering;
  bool get hasPlaylist => _audioHandler.queue.value.isNotEmpty;

  Future<void> setPlaylistAndPlay({
    required String skandhName,
    required List<String> chapterAudioUrls,
    required int initialIndex,
  }) async {
    await _audioHandler.setPlaylist(
      skandhName: skandhName,
      urls: chapterAudioUrls,
      initialIndex: initialIndex,
    );
    await _audioHandler.play();
  }

  Future<void> playAt(int index) async {
    await _audioHandler.player.seek(Duration.zero, index: index);
    await _audioHandler.play();
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await _audioHandler.pause();
    } else {
      await _audioHandler.play();
    }
  }

  Future<void> seek(Duration position) => _audioHandler.seek(position);

  Future<void> playNext() => _audioHandler.skipToNext();

  Future<void> playPrevious() => _audioHandler.skipToPrevious();

  Future<void> _loadLastPlayedTitle() async {
    final prefs = await SharedPreferences.getInstance();
    _lastPlayedTitle = prefs.getString(_lastPlayedTitleKey) ?? '';
    notifyListeners();
  }

  Future<void> _persistLastPlayedTitle(String title) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPlayedTitleKey, title);
  }
}
