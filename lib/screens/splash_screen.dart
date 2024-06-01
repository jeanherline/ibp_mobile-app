import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset("assets/videos/ibp_splash_screen.mp4")
          ..initialize().then((_) {
            setState(() {});
            _controller?.play();
            _controller?.setLooping(false);
          });

    // Navigate to next screen when video completes
    _controller?.addListener(() {
      if (!_controller!.value.isPlaying &&
          _controller!.value.position == _controller!.value.duration) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }
  // }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              )
            : Container(),
      ),
    );
  }
}
