import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/component/video_thumbnail_component.dart';
import 'package:flutter/foundation.dart';
import 'package:jab_training/component/custom_video_player.dart';

class VideoListComponent extends StatefulWidget {
  final String videoType;
  const VideoListComponent({
    super.key,
    required this.videoType,
  });

  @override
  State<VideoListComponent> createState() => _VideoListComponentState();
}

class _VideoListComponentState extends State<VideoListComponent> {
  List<Map<String, dynamic>> videoList = [];

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('videos').select().eq('video_type', widget.videoType);
      setState(() {
        videoList = List<Map<String, dynamic>>.from(response);
      });
    }
    catch (error) {
      if (kDebugMode) {
        debugPrint("Error fetching videos: $error");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: videoList.isEmpty
            ? const Center(child: Text('No videos found'))
            : ListView.builder(
                itemCount: videoList.length,
                itemBuilder: (context, index) {
                  return VideoThumbnailComponent(
                      video: videoList[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomVideoPlayer(
                              videoUrl: videoList[index]['video_url'], // video URL 전달
                            ),
                          ),
                        );
                      },
                  );
                },
            ),
    );
  }
}






































