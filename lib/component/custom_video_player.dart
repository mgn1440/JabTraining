import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:jab_training/component/custom_video_button.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const CustomVideoPlayer({
    super.key,
    required this.videoUrl,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool showControls = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _controller.addListener(_videoControllerListener);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.removeListener(_videoControllerListener);
    super.dispose();
  }

  void _videoControllerListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  children: [
                    VideoPlayer(_controller),
                    if (showControls)
                        Container(
                        color: Colors.black.withOpacity(0.5),
                        ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            renderTimeTextFormDuration(_controller.value.position),
                            Expanded(
                              child: Slider(
                                onChanged: (double val) {
                                  _controller.seekTo(Duration(seconds: val.toInt()));
                                },
                                value: _controller.value.position.inSeconds.toDouble(),
                                min: 0,
                                max: _controller.value.duration.inSeconds.toDouble(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (showControls)
                      Align(
                      alignment: Alignment.topRight,
                      child: CustomVideoButton(
                          onPressed: (){},
                          iconData: Icons.photo_camera_back,
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
                            iconData: _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          CustomVideoButton(
                              onPressed: onForwardPressed,
                              iconData: Icons.rotate_right,
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget renderTimeTextFormDuration(Duration duration) {
    return Text(
      '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
      style: const TextStyle(color: Colors.white),
    );
  }

  void onReversePressed() {
    final currentPosition = _controller.value.position;
    Duration position = const Duration();
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - const Duration(seconds: 3);
    }
    _controller.seekTo(position);
  }

  void onForwardPressed() {
    final maxPosition = _controller.value.duration;
    final currentPosition = _controller.value.position;

    Duration position = maxPosition;
    if ((maxPosition - const Duration(seconds: 3)).inSeconds > currentPosition.inSeconds) {
      position = currentPosition + const Duration(seconds: 3);
    }
    _controller.seekTo(position);
  }

  void onPlayPressed() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }
}







































