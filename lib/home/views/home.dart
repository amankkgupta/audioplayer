import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../assets.dart';
import '../../config/app_constants.dart';
import '../../theme/app_colors.dart';
import 'chapters.dart';
import 'mini_player_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openRateUs() async {
    final inAppReview = InAppReview.instance;
    final canOpenReview = await inAppReview.isAvailable();

    if (canOpenReview) {
      await inAppReview.requestReview();
    }

    await _openExternalUrl(AppConstants.playStoreUrl);
  }

  Future<void> shareApp() async {
    final byteData = await rootBundle.load(Assets.appIcon);

    final tempDir = await getTemporaryDirectory();

    final file = File('${tempDir.path}/icon.jpg');

    await file.writeAsBytes(
      byteData.buffer.asUint8List(),
    );
    await SharePlus.instance.share(
      ShareParams(
        text: AppConstants.shareMessage,
        files: [XFile(file.path)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bhagavad Gita English',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: BoxDecoration(
                  color: AppColors.gradientTop,
                  border: Border(
                    bottom: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.secondary,
                      child: ClipOval(
                        child: Image.asset(
                          Assets.appIcon,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Bhagavad Gita English',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Quick links',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                onTap: () {
                  Navigator.pop(context);
                  _openExternalUrl(AppConstants.privacyPolicyUrl);
                },
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Terms & Conditions'),
                onTap: () {
                  Navigator.pop(context);
                  _openExternalUrl(AppConstants.termsUrl);
                },
              ),
              ListTile(
                leading: const Icon(Icons.apps_rounded),
                title: const Text('More Apps'),
                onTap: () {
                  Navigator.pop(context);
                  _openExternalUrl(AppConstants.moreAppsUrl);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MiniPlayerBar(),
      body: Container(
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _HomeActionCard(
              icon: Icons.music_note_rounded,
              title: 'Audio',
              subtitle: 'Browse chapters',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListAudioScreen(
                      contentMode: ChapterContentMode.audio,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _HomeActionCard(
              icon: Icons.book_rounded,
              title: 'Book',
              subtitle: 'Read PDFs',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListAudioScreen(
                      contentMode: ChapterContentMode.book,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _HomeActionCard(
              icon: Icons.star_rounded,
              title: 'Rate Us',
              subtitle: 'Review the app',
              onTap: _openRateUs,
            ),
            const SizedBox(height: 14),
            _HomeActionCard(
              icon: Icons.share_rounded,
              title: 'Share',
              subtitle: 'Send app link',
              onTap: shareApp,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeActionCard extends StatelessWidget {
  const _HomeActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      overlayColor: WidgetStatePropertyAll(
        AppColors.primary.withValues(alpha: 0.08),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: AppColors.gradientTop,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

enum ChapterContentMode {
  audio,
  book,
}
