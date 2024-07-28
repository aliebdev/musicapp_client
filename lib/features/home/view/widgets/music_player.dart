// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/current_song_notifier.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(currentSongNotifierProvider)!;
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppUtils.hexToColor(song.hexCode),
            Colors.black,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // stops: const [.1, 1],
        ),
      ),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.chevron_down),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Flexible(
                flex: 5,
                child: SafeArea(
                  child: Hero(
                    tag: "music-image",
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(song.thumbnailUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.songName,
                                style: const TextStyle(
                                  color: Pallete.whiteColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                song.artist,
                                style: const TextStyle(
                                  color: Pallete.subtitleText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.heart,
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        StreamBuilder(
                            stream: songNotifier.audioPlayer!.positionStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }
                              final position = snapshot.data;
                              final duration =
                                  songNotifier.audioPlayer!.duration;
                              double sliderValue = 0.0;

                              if (position != null && duration != null) {
                                sliderValue = position.inMilliseconds /
                                    duration.inMilliseconds;
                              }
                              return Column(
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Pallete.whiteColor,
                                      inactiveTickMarkColor:
                                          Pallete.whiteColor.withOpacity(.7),
                                      thumbColor: Pallete.whiteColor,
                                      trackHeight: 4,
                                      overlayShape:
                                          SliderComponentShape.noOverlay,
                                    ),
                                    child: Slider(
                                      value: sliderValue,
                                      onChanged: (value) {},
                                      onChangeEnd: songNotifier.seek,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatDuration(position),
                                        style: const TextStyle(
                                          color: Pallete.subtitleText,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        formatDuration(duration),
                                        style: const TextStyle(
                                          color: Pallete.subtitleText,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.shuffle,
                            size: 25,
                            color: Pallete.subtitleText,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.backward_end_fill,
                            size: 35,
                            color: Pallete.whiteColor,
                          ),
                        ),
                        IconButton(
                          onPressed: songNotifier.playAndPause,
                          icon: Icon(
                            songNotifier.isPlaying
                                ? CupertinoIcons.pause_circle_fill
                                : CupertinoIcons.play_circle_fill,
                            size: 80,
                            color: Pallete.whiteColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.forward_end_fill,
                            size: 35,
                            color: Pallete.whiteColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.repeat,
                            size: 25,
                            color: Pallete.subtitleText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/images/connect-device.png',
                            color: Pallete.whiteColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/images/repeat.png',
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration? duration) {
    if (duration == null) return "00:00";
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
