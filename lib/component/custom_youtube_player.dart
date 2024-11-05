import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';
import 'package:jab_training/component/custom_video_button.dart';

class CustomYoutubePlayer extends StatefulWidget {
  final String videoUrl;

  const CustomYoutubePlayer({
    super.key,
    required this.videoUrl,
  });

  @override
  State<CustomYoutubePlayer> createState() => _CustomYoutubePlayerState();
}

class _CustomYoutubePlayerState extends State<CustomYoutubePlayer> {
  late YoutubePlayerController _controller;
  bool showControls = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        controlsVisibleAtStart: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              showControls = !showControls;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Expanded(
                  child: YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.red,
                      bottomActions: const [
                        CurrentPosition(),
                        ProgressBar(isExpanded: true),
                        RemainingDuration(),
                      ],
                    ),
                    builder: (context, player) {
                      return Stack(
                        children: [
                          player,
                          if (showControls)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          if (showControls)
                            Align(
                              alignment: Alignment.topLeft,
                              child: CustomVideoButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                iconData: Icons.arrow_back,
                              ),
                            ),
                          if (showControls)
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomVideoButton(
                                    onPressed: onReversePressed,
                                    iconData: Icons.rotate_left,
                                  ),
                                  CustomVideoButton(
                                    onPressed: onPlayPressed,
                                    iconData: _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                  CustomVideoButton(
                                    onPressed: onForwardPressed,
                                    iconData: Icons.rotate_right,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onReversePressed() {
    final currentPosition = _controller.value.position;
    Duration newPosition = currentPosition - const Duration(seconds: 3);
    if (newPosition.inSeconds < 0) newPosition = const Duration(seconds: 0);
    _controller.seekTo(newPosition);
  }

  void onForwardPressed() {
    final currentPosition = _controller.value.position;
    Duration newPosition = currentPosition + const Duration(seconds: 3);
    if (newPosition.inSeconds > _controller.metadata.duration.inSeconds) {
      newPosition = _controller.metadata.duration;
    }
    _controller.seekTo(newPosition);
  }

  void onPlayPressed() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }
}
