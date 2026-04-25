import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'pdf_viewer_screen.dart';

class AudioListScreen extends StatelessWidget {

  const AudioListScreen({
    super.key,
    required this.chapterIndex,
    required this.skandhName,
    required this.chapterUrls,
  });

  final int chapterIndex;
  final String skandhName;
  final List<String> chapterUrls;

  String _buildTitle(int index) {
    return '$skandhName Part ${index + 1}';
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PdfViewerScreen(
                    title: _buildTitle(audioIndex),
                    pdfUrl: chapterUrls[audioIndex],
                  ),
                ),
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
                  const Icon(
                    Icons.menu_book_rounded,
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
