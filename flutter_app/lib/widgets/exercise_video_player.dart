import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Plays a YouTube tutorial for the current exercise. The widget rebuilds its
/// player when [videoUrl] changes (e.g., when the user taps "Next exercise").
class ExerciseVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const ExerciseVideoPlayer({super.key, required this.videoUrl});

  @override
  State<ExerciseVideoPlayer> createState() => _ExerciseVideoPlayerState();
}

class _ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _build(widget.videoUrl);
  }

  YoutubePlayerController _build(String url) {
    final id = YoutubePlayer.convertUrlToId(url) ?? '';
    return YoutubePlayerController(
      initialVideoId: id,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void didUpdateWidget(covariant ExerciseVideoPlayer old) {
    super.didUpdateWidget(old);
    if (old.videoUrl != widget.videoUrl) {
      final newId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';
      if (newId.isNotEmpty) {
        _controller.load(newId);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
  }
}
