import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashVideoScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const SplashVideoScreen({
    super.key,
    required this.onFinished,
  });

  @override
  State<SplashVideoScreen> createState() =>
      _SplashVideoScreenState();
}

class _SplashVideoScreenState
    extends State<SplashVideoScreen> {

  late VideoPlayerController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      'assets/videos/thunder_intro.mp4',
    );

    _controller.initialize().then((_) {
      if (!mounted) return;

      setState(() {});
      _controller.play();
    });

    _controller.setLooping(false);

    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >=
              _controller.value.duration &&
          !_navigated) {

        _navigated = true;

        if (mounted) {
          widget.onFinished();
        }
      }
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
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
