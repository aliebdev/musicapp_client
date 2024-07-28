import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_pallete.dart';
import '../widgets/music_slab.dart';
import 'library_page.dart';
import 'songs_page.dart';

class HomePage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;
  final pages = [
    const SongsPage(),
    const LibraryPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[selectedIndex],
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MusicSlab(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home_unfilled.png',
              color: Pallete.inactiveBottomBarItemColor,
            ),
            activeIcon: Image.asset(
              'assets/images/home_filled.png',
              color: Pallete.whiteColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/library.png',
              color: selectedIndex == 1
                  ? Pallete.whiteColor
                  : Pallete.inactiveBottomBarItemColor,
            ),
            // activeIcon: Image.asset('assets/images/library.png'),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
