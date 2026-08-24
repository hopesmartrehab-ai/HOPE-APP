import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/old_core/debug/app_logger.dart';
import '../../core/old_core/l10n/gen/app_localizations.dart';

/// Plays a session video from a presigned S3 URL. Backend regenerates the URL
/// on every GET /sessions/{id}, so reopening the session detail effectively
/// retries with a fresh URL — that's why our local Retry button just rebuilds
/// the controller against the same URL (the parent will refetch on close
/// + reopen if needed).
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl, super.key});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

enum _PlayerStatus { loading, ready, failed }

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  _PlayerStatus _status = _PlayerStatus.loading;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _status = _PlayerStatus.loading);
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _status = _PlayerStatus.ready;
      });
    } catch (e, st) {
      AppLogger.instance.logError('VideoPlayer init failed', e, st);
      await controller.dispose();
      if (!mounted) return;
      setState(() => _status = _PlayerStatus.failed);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    switch (_status) {
      case _PlayerStatus.loading:
        return const SizedBox(
          height: 180,
          child: Center(child: CircularProgressIndicator()),
        );
      case _PlayerStatus.failed:
        return Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam_off, color: Colors.grey, size: 36),
              const SizedBox(height: 8),
              Text(
                t.videoUnavailable,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text(t.retry),
                onPressed: () async {
                  await _controller?.dispose();
                  _controller = null;
                  await _load();
                },
              ),
            ],
          ),
        );
      case _PlayerStatus.ready:
        final c = _controller!;
        return Column(
          children: [
            AspectRatio(
              aspectRatio: c.value.aspectRatio,
              child: VideoPlayer(c),
            ),
            IconButton(
              icon: Icon(c.value.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                setState(() {
                  c.value.isPlaying ? c.pause() : c.play();
                });
              },
            ),
          ],
        );
    }
  }
}
