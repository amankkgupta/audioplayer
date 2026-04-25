import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AppAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  AppAudioHandler() {
    _player.playbackEventStream.listen(_broadcastState);
    _player.durationStream.listen((_) => playbackState.add(_transformState(_player)));
  }

  final AudioPlayer _player = AudioPlayer();
  List<MediaItem> _items = const [];
  int _currentIndex = 0;

  AudioPlayer get player => _player;
  int get currentIndex => _currentIndex;

  Future<void> setPlaylist({
    required String skandhName,
    required List<String> urls,
    required int initialIndex,
  }) async {
    final items = <MediaItem>[
      for (var i = 0; i < urls.length; i++)
        MediaItem(
          id: urls[i],
          album: 'Bhagavad Gita Hindi',
          title: '$skandhName part ${i + 1}',
          artist: skandhName,
        ),
    ];

    _items = items;
    queue.add(items);
    if (items.isEmpty) {
      _currentIndex = 0;
      mediaItem.add(null);
      return;
    }

    _currentIndex = initialIndex.clamp(0, items.length - 1);
    await _loadCurrentItem();
  }

  Future<void> _loadCurrentItem() async {
    if (_items.isEmpty || _currentIndex < 0 || _currentIndex >= _items.length) {
      return;
    }

    final item = _items[_currentIndex];
    await _player.setAudioSource(
      AudioSource.uri(Uri.parse(item.id), tag: item),
    );
    mediaItem.add(item);
    playbackState.add(_transformState(_player));
  }

  void _broadcastState(PlaybackEvent event) {
    playbackState.add(_transformState(_player));
  }

  PlaybackState _transformState(AudioPlayer player) {
    return PlaybackState(
      controls: const [],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[player.processingState]!,
      playing: player.playing,
      updatePosition: player.position,
      bufferedPosition: player.bufferedPosition,
      speed: player.speed,
      queueIndex: _currentIndex,
    );
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    if (_currentIndex >= _items.length - 1) return;
    _currentIndex += 1;
    await _loadCurrentItem();
    await _player.play();
  }

  @override
  Future<void> skipToPrevious() async {
    if (_currentIndex <= 0) return;
    _currentIndex -= 1;
    await _loadCurrentItem();
    await _player.play();
  }
}
