import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../viewmodals/player_view_model.dart';
import 'home.dart';
import 'mini_player_bar.dart';
import 'pdf_viewer_screen.dart';
import 'player.dart';

class AudioListScreen extends StatelessWidget {
  const AudioListScreen({
    super.key,
    required this.contentMode,
    required this.chapterIndex,
    required this.skandhName,
    required this.chapterUrls,
  });

  final ChapterContentMode contentMode;
  final int chapterIndex;
  final String skandhName;
  final List<String> chapterUrls;

  String _buildTitle(int index) {
    return '$skandhName Part ${index + 1}';
  }

  void _openPlayer(
    BuildContext context, {
    required PlayerVm playerVm,
    required int audioIndex,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PlayerScreen(),
      ),
    );
    unawaited(
      playerVm.setPlaylistAndPlay(
        skandhName: skandhName,
        chapterAudioUrls: chapterUrls,
        initialIndex: audioIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          skandhName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      bottomNavigationBar: const MiniPlayerBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: chapterUrls.length,
        itemBuilder: (context, index) {
          final audioIndex = index;
          if (audioIndex >= chapterUrls.length) {
            return const SizedBox.shrink();
          }

          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              if (contentMode == ChapterContentMode.book) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PdfViewerScreen(
                      title: _buildTitle(audioIndex),
                      pdfUrl: chapterUrls[audioIndex],
                    ),
                  ),
                );
                return;
              }

              final playerVm = context.read<PlayerVm>();
              _openPlayer(
                context,
                playerVm: playerVm,
                audioIndex: audioIndex,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _buildTitle(audioIndex),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    contentMode == ChapterContentMode.book
                        ? Icons.menu_book_rounded
                        : Icons.play_circle_fill_rounded,
                    size: 28,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
