// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({
    super.key,
    required this.path,
  });

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.path);
  }

  Future<void> playAndPause() async {
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer(finishMode: FinishMode.stop);
    } else if (!playerController.playerState.isPaused) {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: playAndPause,
          icon: Icon(
            playerController.playerState.isPlaying
                ? CupertinoIcons.pause_solid
                : CupertinoIcons.play_arrow_solid,
          ),
        ),
        Expanded(
          child: AudioFileWaveforms(
            playerController: playerController,
            size: const Size.fromHeight(100),
            playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: Pallete.borderColor,
              liveWaveColor: Pallete.gradient2,
              spacing: 6,
              showSeekLine: false,
            ),
            // waveformType: WaveformType.fitWidth,
          ),
        ),
      ],
    );
  }
}
