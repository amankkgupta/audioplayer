import 'package:bhagavad_gita_english/splash_screen.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home/viewmodals/home_view_model.dart';
import 'home/viewmodals/player_view_model.dart';
import 'home/services/audio_handler.dart';
import 'home/views/chapters.dart';
import 'home/views/home.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final audioHandler = await AudioService.init<AppAudioHandler>(
    builder: () => AppAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.apps.bhagavadgitaenglish.channel.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<HomeVm>(
        create: (context) => HomeVm(),
      ),
      ChangeNotifierProvider<PlayerVm>(
        create: (context) => PlayerVm(
          audioHandler: audioHandler,
        ),
      ),
    ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seedBlue,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.surface,
    );

    return MaterialApp(
      title: 'Bhagavad Gita English',
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        cardColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: colorScheme.primary,
          contentTextStyle: const TextStyle(color: Colors.white),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: colorScheme.primary,
          inactiveTrackColor: colorScheme.primary.withValues(alpha: 0.18),
          thumbColor: colorScheme.primary,
          overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: colorScheme.primary,
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/audiolist': (context) => const ListAudioScreen(
          contentMode: ChapterContentMode.audio,
        ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
