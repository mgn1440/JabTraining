import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class VideoComponent extends StatefulWidget {
  const VideoComponent({super.key});

  @override
  State<VideoComponent> createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  List<Map<String, dynamic>> videoList = [];

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('videos').select();
      print(response);
      setState(() {
        videoList = List<Map<String, dynamic>>.from(response);
        if (videoList.isNotEmpty) {
          _initializeVideoPlayer(videoList[0]['video_url']);
        }
      });
    }
    catch (error) {
      if (kDebugMode) {
        debugPrint("Error fetching videos: $error");
      }
    }
  }

  void _initializeVideoPlayer(String videoUrl) {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
    )
      ..initialize().then((_) {
        setState(() {}); // 비디오 초기화 후 UI 업데이트
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: videoList.isEmpty
            ? const Center(child: Text('No videos found'))
            : ListView.builder(
            itemCount: videoList.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildVideoPlayer();
              } else {
                return _buildVideoThumbnail(videoList[index]);
              }
            },
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                VideoProgressIndicator(_controller, allowScrubbing: true),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                      _isPlaying ? _controller.play() : _controller.pause();
                    });
                  },
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                )
              ],
            ),
          )
        : const CircularProgressIndicator(); // 비디오 로드 x
  }

  Widget _buildVideoThumbnail(Map<String, dynamic> video) {
    return ListTile(
      leading: Image.network(
          video['thumbnail_url'],
          fit: BoxFit.cover,
        width: 100.0,
      ),
      title: Text(video['title']),
      onTap: () {
        _initializeVideoPlayer(video['video_url']);
      },
    );
  }
}






































