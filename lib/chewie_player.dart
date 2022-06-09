import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_example/video_player.dart';

class VideoAppAlternative extends StatefulWidget {
  const VideoAppAlternative({Key? key}) : super(key: key);

  @override
  State<VideoAppAlternative> createState() => _VideoAppAlternativeState();
}

class _VideoAppAlternativeState extends State<VideoAppAlternative> {
  final videoPlayerController = VideoPlayerController.network(
    VIDEO_URL,
  );

  ChewieController? chewieController;

  Future<void> initializePlayer() async {
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      allowPlaybackSpeedChanging: false,
      showOptions: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.orange,
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: chewieController != null &&
              chewieController!.videoPlayerController.value.isInitialized
          ? SafeArea(
              child: AspectRatio(
                aspectRatio:
                    chewieController!.videoPlayerController.value.aspectRatio,
                child: Chewie(
                  controller: chewieController!,
                ),
              ),
            )
          : Center(
              child: CupertinoActivityIndicator(),
            ),
    );
  }
}

class CustomController extends ChewieController {
  CustomController({required VideoPlayerController videoPlayerController})
      : super(videoPlayerController: videoPlayerController);
}
