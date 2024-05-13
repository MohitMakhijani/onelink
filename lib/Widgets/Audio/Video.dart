
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget(this.videoUrl);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          // Video initially paused
          _isPlaying = false;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        _controller.pause();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          ),
        ).then((_) {
          // Resume video when returning from full screen
          _controller.play();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _togglePlayPause();
        if (!_isPlaying) {
          _toggleFullScreen();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            child: VideoPlayer(_controller),
          ),
          if (!_isPlaying)
            Icon(
              Icons.play_arrow,
              size: 50,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget(this.audioUrl);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _playerState = state;
      });
    });
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _initAudioPlayer() async {
    await _audioPlayer.setSourceUrl(widget.audioUrl);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.audioUrl);
    return Column(
      children: [
        IconButton(
          icon: _playerState == PlayerState.playing
              ? Icon(Icons.pause)
              : Icon(Icons.play_arrow),
          onPressed: () {
            if (_playerState == PlayerState.playing) {
              _audioPlayer.pause();
            } else if (_playerState == PlayerState.playing) {
              _audioPlayer.resume();
            } else {
              _audioPlayer
                ..setSourceUrl(
                  widget.audioUrl,
                );
            }
          },
        ),
        StreamBuilder<PlayerState>(
          stream: _audioPlayer.onPlayerStateChanged,
          builder: (context, snapshot) {
            return Container(
              child: Text(snapshot.data.toString()),
            );
          },
        ),
      ],
    );
  }
}