import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

const VIDEO_URL =
    'https://storage.googleapis.com/cariilmu-storage/Courses/Cara%20Praktis%20Membuat%20Aneka%20Masakan%20Oriental%20Bersama%20Chef%20Bara/40%20Bumbu%20dasar%20Jepang%2C%20Roll%2018%20take%201.mp4';

class VideoApp extends StatefulWidget {
  const VideoApp({Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  bool isPotrait = true;
  bool showIndicator = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setPotrait();
    _controller = VideoPlayerController.network(
      VIDEO_URL,
    )
      ..play()
      ..addListener(() {
        // print(getPosition());
        setState(() {});
      });
    _controller.initialize().then((value) {
      setState(() {});
    });
  }

  Future setLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future setPotrait() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  String getPosition() {
    final duration = Duration(
      milliseconds: _controller.value.position.inMilliseconds.round(),
    );
    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  String videoLength() {
    final duration = _controller.value.duration;
    return [duration.inMinutes, duration.inSeconds]
        .map((e) => e.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
    final size = _controller.value.size;
    return SafeArea(
      child: Scaffold(
        body: !_controller.value.isInitialized
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : Container(
                alignment: Alignment.topCenter,
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    bool _isPotrait = orientation == Orientation.portrait;
                    isPotrait = _isPotrait;
                    return _isPotrait
                        ? Stack(
                            children: [
                              _isPotrait
                                  ? const SizedBox(height: 16)
                                  : Container(),
                              _isPotrait
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 230),
                                      child: ListView.builder(
                                        itemCount: 50,
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemBuilder: (context, i) => Text('$i'),
                                      ),
                                    )
                                  : Container(),
                              buildVideoPlayer(size, _isPotrait),
                            ],
                          )
                        : buildVideoPlayer(size, _isPotrait);
                  },
                ),
              ),
      ),
    );
  }

  Widget buildVideoPlayer(Size size, bool _isPotrait) {
    return Stack(
      fit: _isPotrait ? StackFit.loose : StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(
                _controller,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    showIndicator = !showIndicator;
                    if (showIndicator) {
                      Future.delayed(Duration(seconds: 3), (() {
                        showIndicator = false;
                      }));
                    }
                  });
                },
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 50),
                reverseDuration: const Duration(milliseconds: 200),
                child: !showIndicator
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            showIndicator = !showIndicator;
                            if (showIndicator) {
                              Future.delayed(Duration(seconds: 3), (() {
                                showIndicator = false;
                              }));
                            }
                          });
                        },
                        child: Container(
                          color: Colors.black26,
                        ),
                      ),
              ),
              if (showIndicator) ...[
                if (!isPotrait)
                  Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                      width:
                          _controller.value.isPlaying ? 0 : size.width * 0.25,
                      height: _controller.value.isPlaying ? 0 : size.height,
                      color: Colors.black,
                      child: ListView.builder(
                        itemCount: 30,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, i) => Text(
                            'Bumbu Dasar Jepang (Bagian ${i + 1})',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                  child: Center(
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_isPotrait) {
                        setLandscape();
                      } else {
                        setPotrait();
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          bottom: 4,
                        ),
                        child: Text('${getPosition()} - ${videoLength()}',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}