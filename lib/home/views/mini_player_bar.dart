import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../viewmodals/player_view_model.dart';
import 'player.dart';

class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerVm>(
      builder: (context, playerVm, _) {
        if (!playerVm.hasPlaylist) {
          return const SizedBox.shrink();
        }

        return SafeArea(
          top: false,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlayerScreen(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.gradientTop,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.music_note_rounded,
                      size: 28,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playerVm.currentTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            playerVm.skandhName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_up_rounded,
                      size: 28,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
