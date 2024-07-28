import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/current_song_notifier.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/loader.dart';
import '../../viewmodel/home_viewmodel.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs =
        ref.read(homeViewModelProvider.notifier).getRecentlyPlayedSongs();
    final currentSong = ref.watch(currentSongNotifierProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: currentSong == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppUtils.hexToColor(currentSong.hexCode),
                  Pallete.transparentColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [.0, .3],
              ),
            ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recentlyPlayedSongs.isNotEmpty)
              SizedBox(
                height: 280,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16)
                      .copyWith(bottom: 36, top: 10),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: recentlyPlayedSongs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final song = recentlyPlayedSongs.elementAt(index);
                    return GestureDetector(
                      onTap: () => ref
                          .read(currentSongNotifierProvider.notifier)
                          .updateSong(song),
                      child: Container(
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Pallete.borderColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(song.thumbnailUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              song.songName,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Latest to listen',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ref.watch(getAllSongsProvider).when(
                  data: (songs) {
                    return SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: songs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final song = songs.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(currentSongNotifierProvider.notifier)
                                  .updateSong(song);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 180,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      image: DecorationImage(
                                        image: NetworkImage(song.thumbnailUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    song.songName,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    song.artist,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Pallete.subtitleText,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(error.toString()),
                    );
                  },
                  loading: () => const Loader(),
                ),
          ],
        ),
      ),
    );
  }
}
