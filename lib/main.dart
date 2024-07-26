import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/current_user_notifier.dart';
import 'core/theme/theme.dart';
import 'features/auth/view/pages/signup_page.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/home/view/pages/upload_song_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: currentUser == null ? const SignUpPage() : const UploadSongPage(),
    );
  }
}
