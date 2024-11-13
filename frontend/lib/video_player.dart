import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _showSubtitles = true;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'kOkqJlJM0Sw',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('客語影片學習'),
        actions: [
          IconButton(
            icon: Icon(_showSubtitles ? Icons.subtitles : Icons.subtitles_off),
            onPressed: () {
              setState(() {
                _showSubtitles = !_showSubtitles;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.teal,
          ),
          if (_showSubtitles)
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: const Column(
                children: [
                  Text(
                    '𠊎係細阿妹', // 客語漢字
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ngai he se a moi', // 客語拼音
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
} 