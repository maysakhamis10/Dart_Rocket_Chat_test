import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ChewieVideoPlayer extends StatefulWidget {
  final String fileUrl;
  final bool looping, autoPlay;
  final double aspectRatio;

  const ChewieVideoPlayer({
    this.fileUrl = "",
    this.looping = false,
    this.autoPlay = false,
    this.aspectRatio = 16 / 9,
  });

  @override
  _ChewieVideoPlayerState createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer> {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;

  String fileUrl;
  bool looping, autoPlay;
  double aspectRatio;
  Function callbackFunction;

  void initData() {
    fileUrl = widget.fileUrl;
    looping = widget.looping;
    autoPlay = widget.autoPlay;
    aspectRatio = widget.aspectRatio;
  }

  @override
  void initState() {
    super.initState();
    initData();

    if (fileUrl != "" && fileUrl.isNotEmpty) {
      _videoPlayerController = VideoPlayerController.network(fileUrl);
    }

    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        looping: looping,
        aspectRatio: aspectRatio,
        autoPlay: autoPlay,
        autoInitialize: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }
}
