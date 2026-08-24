import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../config.dart';
import '../../core/old_core/debug/app_logger.dart';
import '../../core/old_core/debug/debug_log_entry.dart';
import '../../core/old_core/debug/debug_log_store.dart';
import '../../core/old_core/debug/logging_http_client.dart';
import '../../core/old_core/services/api_service.dart';
import '../../core/old_core/services/video_service.dart';
import '../models/session.dart';

enum SessionState {
  idle,
  creatingSession,
  linkingDevice,
  waitingForAssessment,
  assessmentDone,
  questionnaire,
  waitingForExercise,
  exerciseDone,
}

class SessionProvider extends ChangeNotifier {
  late final ApiService _api;
  late final VideoService _video;
  final DebugLogStore logStore;

  SessionState _state = SessionState.idle;
  Session? _currentSession;
  String? _errorMessage;
  // Sentinel values for errors that the UI should localize. The raw
  // _errorMessage carries either a sentinel here or a fallback string.
  static const String errorNoNetwork = '__no_network__';
  Timer? _pollingTimer;
  int _pollCount = 0;

  // Backend accumulates sensor data for 3 min (assessment) or 5 min (exercise)
  // before scoring. Poll for up to 7 minutes to cover 5-min exercise + buffer.
  static const int _maxPolls = 420; // 7 minutes at 1s intervals
  static const Duration _pollInterval = Duration(seconds: 1);

  SessionProvider({DebugLogStore? logStore})
    : logStore = logStore ?? DebugLogStore() {
    final client = LoggingHttpClient(store: this.logStore);
    _api = ApiService(client);
    _video = VideoService(client);
  }

  SessionState get state => _state;
  Session? get currentSession => _currentSession;
  String? get errorMessage => _errorMessage;

  // --- Accumulation helpers (derived from _currentSession, refreshed each poll) ---

  /// True when the glove appears disconnected: accumulation has started but
  /// no batch arrived in the last 15 seconds, OR accumulation started but
  /// lastBatchAt is still null (device never sent data).
  bool get deviceDisconnected {
    final session = _currentSession;
    if (session == null) return false;
    final started = session.ingestStartedAt;
    if (started == null) return false;
    final lastBatch = DateTime.tryParse(session.lastBatchAt ?? '');
    if (lastBatch == null) return true; // started but no batch ever received
    return DateTime.now().toUtc().difference(lastBatch).inSeconds > 15;
  }

  DateTime? get accumulationStartedAt =>
      DateTime.tryParse(_currentSession?.ingestStartedAt ?? '');

  DateTime? get lastBatchTime =>
      DateTime.tryParse(_currentSession?.lastBatchAt ?? '');

  int get batchCount => _currentSession?.batchCount ?? 0;

  int get secondsRequired => _currentSession?.secondsRequired ?? 180;

  String? get accumulationPhase => _currentSession?.accumulationPhase;

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void _setState(SessionState newState) {
    if (_state == newState) return;
    final prev = _state.name;
    _state = newState;
    AppLogger.instance.logStateChange(prev, newState.name);
    logStore.addStateChange(
      StateChangeEvent(
        from: prev,
        to: newState.name,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> startSession() async {
    _setState(SessionState.creatingSession);
    try {
      final sessionId = await _api.createSession();
      // Single-glove demo: link the hardcoded device automatically. The user
      // never picks a device — the firmware's DEVICE_ID matches defaultDeviceId.
      _setState(SessionState.linkingDevice);
      await _api.linkDevice(sessionId, defaultDeviceId);
      _currentSession = await _api.getSession(sessionId);
      _setState(SessionState.waitingForAssessment);
    } on NoNetworkException {
      _errorMessage = errorNoNetwork;
      _setState(SessionState.idle);
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _setState(SessionState.idle);
    } catch (e) {
      _errorMessage = 'Failed to create session';
      _setState(SessionState.idle);
    }
  }

  Future<void> submitQuestionnaire(Map<String, dynamic> answers) async {
    if (_currentSession == null) return;
    try {
      await _api.submitQuestionnaire(_currentSession!.sessionId, answers);
      _setState(SessionState.waitingForExercise);
    } on NoNetworkException {
      _errorMessage = errorNoNetwork;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to submit questionnaire';
      notifyListeners();
    }
  }

  void skipQuestionnaire() {
    _setState(SessionState.waitingForExercise);
  }

  Future<void> redoAssessment() async {
    if (_currentSession == null) return;
    _pollingTimer?.cancel();
    _pollCount = 0;
    try {
      await _api.redoAssessment(_currentSession!.sessionId);
      _currentSession = await _api.getSession(_currentSession!.sessionId);
      _setState(SessionState.waitingForAssessment);
    } on NoNetworkException {
      _errorMessage = errorNoNetwork;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to restart assessment';
      notifyListeners();
    }
  }

  Future<bool> deleteSession(String sessionId) async {
    try {
      await _api.deleteSession(sessionId);
      _sessionHistory = _sessionHistory
          .where((s) => s.sessionId != sessionId)
          .toList();
      notifyListeners();
      return true;
    } on NoNetworkException {
      _errorMessage = errorNoNetwork;
      notifyListeners();
      return false;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete session';
      notifyListeners();
      return false;
    }
  }

  void startPollingForAssessment() {
    if (_currentSession == null) return;
    _pollCount = 0;
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollInterval, (_) => _pollAssessment());
  }

  Future<void> _pollAssessment() async {
    if (_currentSession == null) {
      _pollingTimer?.cancel();
      return;
    }
    _pollCount++;
    if (_pollCount > _maxPolls) {
      _pollingTimer?.cancel();
      _errorMessage = 'Assessment timed out. Please try again.';
      _setState(SessionState.idle);
      return;
    }
    try {
      final session = await _api.getSession(_currentSession!.sessionId);
      _currentSession = session;
      if (session.assessmentResults != null) {
        _pollingTimer?.cancel();
        _setState(SessionState.assessmentDone);
      }
    } on ApiException catch (e) {
      AppLogger.instance.logError('Poll assessment error', e);
    }
  }

  void startPollingForExercise() {
    if (_currentSession == null) return;
    _pollCount = 0;
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollInterval, (_) => _pollExercise());
  }

  Future<void> _pollExercise() async {
    if (_currentSession == null) {
      _pollingTimer?.cancel();
      return;
    }
    _pollCount++;
    if (_pollCount > _maxPolls) {
      _pollingTimer?.cancel();
      _errorMessage = 'Exercise timed out. Please try again.';
      _setState(SessionState.assessmentDone);
      return;
    }
    try {
      final session = await _api.getSession(_currentSession!.sessionId);
      _currentSession = session;
      if (session.exerciseResults != null) {
        _pollingTimer?.cancel();
        _setState(SessionState.exerciseDone);
      }
    } on ApiException catch (e) {
      AppLogger.instance.logError('Poll exercise error', e);
    }
  }

  Future<bool> uploadSessionVideo(File videoFile) async {
    if (_currentSession == null) return false;
    try {
      final uploadUrl = await _api.getVideoUploadUrl(
        _currentSession!.sessionId,
      );
      await _video.uploadVideoWithUrl(uploadUrl, videoFile);
      AppLogger.instance.logInfo('Video uploaded successfully');
      return true;
    } on NoNetworkException {
      _errorMessage = errorNoNetwork;
      notifyListeners();
      return false;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to upload video';
      notifyListeners();
      return false;
    }
  }

  // --- Simulator ---

  bool _simulating = false;
  bool get isSimulating => _simulating;

  Future<void> simulateGlove() async {
    if (_currentSession == null) return;
    final deviceId = _currentSession!.deviceId;
    if (deviceId == null) return;

    _simulating = true;
    notifyListeners();
    try {
      await _api.simulateGlove(deviceId);
      AppLogger.instance.logInfo('Glove simulated for device $deviceId');
    } on NoNetworkException {
      _errorMessage = errorNoNetwork;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Simulation failed';
    } finally {
      _simulating = false;
      notifyListeners();
    }
  }

  // --- Practitioner ---

  List<SessionSummary> _sessionHistory = [];
  List<SessionSummary> get sessionHistory => List.unmodifiable(_sessionHistory);

  Future<void> loadSessionHistory() async {
    try {
      _sessionHistory = await _api.listSessions();
      notifyListeners();
    } on NoNetworkException {
      _errorMessage = errorNoNetwork;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load sessions';
      notifyListeners();
    }
  }

  Future<Session?> loadSessionDetail(String sessionId) async {
    try {
      return await _api.getSession(sessionId);
    } on ApiException {
      return null;
    } catch (e) {
      return null;
    }
  }

  void resetSession() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _pollCount = 0;
    _currentSession = null;
    _errorMessage = null;
    _setState(SessionState.idle);
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
