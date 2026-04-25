import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../assets.dart';
import '../../theme/app_colors.dart';
import '../viewmodals/player_view_model.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  double? _dragValueMillis;

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = d.inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerVm>(
      builder: (context, playerVm, _) {
        final canGoPrevious = playerVm.currentIndex > 0;
        final canGoNext = playerVm.currentIndex < playerVm.chapterAudioUrls.length - 1;
        final maxMillis =
            playerVm.duration.inMilliseconds > 0 ? playerVm.duration.inMilliseconds : 1;
        final sliderValue = ((_dragValueMillis ?? playerVm.position.inMilliseconds.toDouble())
                .clamp(0, maxMillis.toDouble()))
            .toDouble();
        final displayedPosition = Duration(milliseconds: sliderValue.toInt());
        final canDragSeek = playerVm.duration > Duration.zero;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              playerVm.hasPlaylist
                  ? '${playerVm.skandhName} अध्याय ${playerVm.currentIndex + 1}'
                  : 'Bhagavad Gita Hindi Player',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gradientTop,
                  AppColors.gradientMiddle,
                  AppColors.gradientBottom,
                ],
              ),
            ),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(22),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      Assets.appIcon,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Slider(
                  min: 0,
                  max: maxMillis.toDouble(),
                  value: sliderValue,
                  onChangeStart: canDragSeek
                      ? (value) {
                          setState(() {
                            _dragValueMillis = value;
                          });
                        }
                      : null,
                  onChanged: canDragSeek
                      ? (value) {
                          setState(() {
                            _dragValueMillis = value;
                          });
                        }
                      : null,
                  onChangeEnd: canDragSeek
                      ? (value) {
                          playerVm.seek(Duration(milliseconds: value.toInt()));
                          setState(() {
                            _dragValueMillis = null;
                          });
                        }
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_format(displayedPosition)),
                      Text(_format(playerVm.duration)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: canGoPrevious ? playerVm.playPrevious : null,
                      iconSize: 34,
                      icon: const Icon(Icons.skip_previous_rounded),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: playerVm.isLoading ? null : playerVm.togglePlayPause,
                      iconSize: 58,
                      icon: playerVm.isLoading
                          ? SizedBox(
                              width: 46,
                              height: 46,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            )
                          : Icon(
                              playerVm.isPlaying
                                  ? Icons.pause_circle_filled_rounded
                                  : Icons.play_circle_fill_rounded,
                            ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: canGoNext ? playerVm.playNext : null,
                      iconSize: 34,
                      icon: const Icon(Icons.skip_next_rounded),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
