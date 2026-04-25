import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../assets.dart';
import '../../theme/app_colors.dart';
import '../viewmodals/home_view_model.dart';
import 'audio_list.dart';

class ListAudioScreen extends StatefulWidget {
  const ListAudioScreen({super.key});

  @override
  State<ListAudioScreen> createState() => _ListAudioScreenState();
}

class _ListAudioScreenState extends State<ListAudioScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeVm = context.read<HomeVm>();
      if (homeVm.bookList.isEmpty && !homeVm.isLoading) {
        homeVm.fetchBooks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bhagavad Gita Hindi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: Consumer<HomeVm>(
        builder: (context, audioVm, _) {
          final chapterList = audioVm.bookList;
          final onRetry = audioVm.fetchBooks;

          if (audioVm.isLoading && chapterList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (audioVm.errorMessage != null && chapterList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      audioVm.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: onRetry,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: chapterList.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final chapterIndex = index;
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  if (chapterIndex >= chapterList.length) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Book list not loaded yet')),
                    );
                    return;
                  }

                  if (chapterList[chapterIndex].pdfUrls.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Book PDF not available')),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AudioListScreen(
                        chapterIndex: chapterIndex,
                        skandhName: chapterList[chapterIndex].title,
                        chapterUrls: chapterList[chapterIndex].pdfUrls,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: AppColors.gradientTop,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          Assets.appIcon,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          chapterList[chapterIndex].title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
