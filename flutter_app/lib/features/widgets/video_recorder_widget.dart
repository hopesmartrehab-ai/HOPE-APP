import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:provider/provider.dart';

import '../../core/old_core/debug/app_logger.dart';
import '../state/session_provider.dart';

/// Button that opens a fullscreen modal for recording + uploading a session
/// video. The camera is only powered up while the modal is on screen, so
/// idle exercise time isn't burning battery on a live preview.
///
/// After a successful upload the button switches to a "✓ video uploaded /
/// re-record" state. Tapping again replaces the previous video.
class VideoRecorderWidget extends StatefulWidget {
  const VideoRecorderWidget({super.key});

  @override
  State<VideoRecorderWidget> createState() => _VideoRecorderWidgetState();
}

class _VideoRecorderWidgetState extends State<VideoRecorderWidget> {
  bool _hasUpload = false;

  Future<void> _open() async {
    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const _RecorderModal(),
      ),
    );
    if (!mounted || ok != true) return;
    setState(() => _hasUpload = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_hasUpload) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 18),
              const SizedBox(width: 6),
              Text(
                LocaleKeys.videoUploaded.tr(),
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 6),
          OutlinedButton.icon(
            icon: const Icon(Icons.replay),
            label: Text(LocaleKeys.reRecord.tr()),
            onPressed: _open,
          ),
        ],
      );
    }
    return OutlinedButton.icon(
      icon: const Icon(Icons.videocam_outlined),
      label: Text(LocaleKeys.recordVideoOfYourself.tr()),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: _open,
    );
  }
}

/// Fullscreen modal: camera preview + record/stop button. Pops `true` after
/// a successful upload, `false` (or null) if the user backs out.
class _RecorderModal extends StatefulWidget {
  const _RecorderModal();

  @override
  State<_RecorderModal> createState() => _RecorderModalState();
}

class _RecorderModalState extends State<_RecorderModal> {
  CameraController? _controller;
  bool _initFailed = false;
  bool _recording = false;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _initFailed = true);
        return;
      }
      final cam = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      // medium ≈ 480p — keeps uploads fast on iPhone / modern devices.
      final controller = CameraController(
        cam,
        ResolutionPreset.medium,
        enableAudio: true,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (e, st) {
      AppLogger.instance.logError('Camera init failed', e, st);
      if (mounted) setState(() => _initFailed = true);
    }
  }

  Future<void> _start() async {
    final c = _controller;
    if (c == null || _recording) return;
    try {
      await c.startVideoRecording();
      if (!mounted) return;
      setState(() => _recording = true);
    } catch (e, st) {
      AppLogger.instance.logError('startVideoRecording failed', e, st);
    }
  }

  Future<void> _stopAndUpload() async {
    final c = _controller;
    if (c == null || !_recording) return;
    final provider = context.read<SessionProvider>();
    XFile file;
    try {
      file = await c.stopVideoRecording();
    } catch (e, st) {
      AppLogger.instance.logError('stopVideoRecording failed', e, st);
      if (mounted) setState(() => _recording = false);
      return;
    }
    if (!mounted) return;
    setState(() {
      _recording = false;
      _uploading = true;
    });
    final ok = await provider.uploadSessionVideo(File(file.path));
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _uploading = false);
      // SessionProvider already set errorMessage; the parent screen will show
      // the snackbar via showSessionError on its next build.
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(LocaleKeys.recordVideo.tr()),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
          tooltip: LocaleKeys.close.tr(),
        ),
      ),
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    if (_initFailed) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            LocaleKeys.cameraNotAvailable.tr(),
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final c = _controller;
    if (c == null || !c.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: c.value.aspectRatio,
              child: CameraPreview(c),
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.all(24), child: _controlBar()),
      ],
    );
  }

  Widget _controlBar() {
    if (_uploading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            LocaleKeys.uploadingVideo.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      );
    }
    if (_recording) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _RecordingDot(),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            icon: const Icon(Icons.stop),
            label: Text(LocaleKeys.stopRecording.tr()),
            onPressed: _stopAndUpload,
          ),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LocaleKeys.tapToStart.tr(),
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 72,
          height: 72,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
            ),
            onPressed: _start,
            child: const Icon(
              Icons.fiber_manual_record,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }
}

/// Pulsing red dot + "Recording…" label so the user knows the camera is hot.
class _RecordingDot extends StatefulWidget {
  const _RecordingDot();

  @override
  State<_RecordingDot> createState() => _RecordingDotState();
}

class _RecordingDotState extends State<_RecordingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _ctl,
          child: const Icon(
            Icons.fiber_manual_record,
            color: Colors.red,
            size: 14,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          LocaleKeys.videoRecording.tr(),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
