import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import 'core/providers/current_user_notifier.dart';
import 'core/theme/theme.dart';
import 'features/auth/view/pages/signup_page.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/home/view/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;

  final container = ProviderContainer();
  final notifier = container.read(authViewModelProvider.notifier);
  await notifier.initSharedPreferences();
  await notifier.getData();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: currentUser == null ? const SignUpPage() : const HomePage(),
    );
  }
}
