import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../../../config.dart';
import '../../../features/models/session.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}

/// Thrown when an HTTP call fails because the device has no network. Higher
/// layers turn this into a localized "no internet" message instead of the
/// raw "Failed to ..." snackbar.
class NoNetworkException extends ApiException {
  const NoNetworkException() : super('no_network');
}

/// Run a network call and re-throw network failures as NoNetworkException so
/// the UI layer can show "no internet" instead of a generic error.
Future<T> _network<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on SocketException {
    throw const NoNetworkException();
  } on TimeoutException {
    throw const NoNetworkException();
  } on http.ClientException {
    throw const NoNetworkException();
  }
}

class ApiService {
  final http.Client _client;

  ApiService(this._client);

  Future<String> createSession() => _network(() async {
    final response = await _client.post(
      Uri.parse('$apiBaseUrl/sessions'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw ApiException('Failed to create session: ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['session_id'] as String;
  });

  Future<void> submitQuestionnaire(
    String sessionId,
    Map<String, dynamic> answers,
  ) => _network(() async {
    final response = await _client.put(
      Uri.parse('$apiBaseUrl/sessions/$sessionId/questionnaire'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(answers),
    );
    if (response.statusCode != 200) {
      throw ApiException(
        'Failed to submit questionnaire: ${response.statusCode}',
      );
    }
  });

  Future<void> linkDevice(String sessionId, String deviceId) =>
      _network(() async {
        final response = await _client.put(
          Uri.parse('$apiBaseUrl/sessions/$sessionId/device'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'device_id': deviceId}),
        );
        if (response.statusCode != 200) {
          throw ApiException('Failed to link device: ${response.statusCode}');
        }
      });

  Future<Session> getSession(String sessionId) => _network(() async {
    final response = await _client.get(
      Uri.parse('$apiBaseUrl/sessions/$sessionId'),
    );
    if (response.statusCode != 200) {
      throw ApiException('Failed to get session: ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Session.fromJson(data);
  });

  Future<List<SessionSummary>> listSessions() => _network(() async {
    final response = await _client.get(Uri.parse('$apiBaseUrl/sessions'));
    if (response.statusCode != 200) {
      throw ApiException('Failed to list sessions: ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['sessions'] as List<dynamic>;
    return items
        .map((e) => SessionSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  });

  /// Simulate the glove by sending a batch of sensor data to /ingest.
  /// Matches the exact format the ESP32 firmware sends: 100 samples at 50ms
  /// intervals with realistic sensor ranges. The backend auto-detects whether
  /// to run assessment or exercise logic from the session's status — the glove
  /// (and this simulation) never need to specify a phase.
  Future<void> simulateGlove(String deviceId) =>
      _network(() => _simulateGlove(deviceId));

  Future<void> _simulateGlove(String deviceId) async {
    final rng = Random();

    // Pick a random patient profile so each run produces different assessment
    // results across the spectrum. The thresholds in
    // backend/lambdas/hope_ingest/assess_logic.py are tuned for normalized
    // (g / °/s) values, so we feed values in those units rather than raw LSB.
    //   - Reach:        rom>60 AND 1<speed<3 AND traj>0.85 AND dev<2000
    //   - Grasp:        force>50 AND flex>40
    //   - Manipulation: traj>0.8 AND duration<6
    //   - Release:      force<20 AND flex<20
    //
    // Profiles are tuned so each one steers `needed_training[0]` to a
    // different exercise, so the demo doesn't always score the same one.
    //   0 → fail Reach        (low gx, low speed)
    //   1 → fail Grasp        (low force/flex, otherwise OK)
    //   2 → fail Manipulation (low trajectory smoothness)
    //   3 → fail Release      (high force/flex, otherwise OK)
    final profile = rng.nextInt(4);

    // gx in °/s integrated over 50ms; backend clamps |angle|<=90.
    final gxAmplitude = [12.0, 80.0, 80.0, 80.0][profile];

    // Mean |accel| target (in g) → drives `speed` (threshold: 1<speed<3).
    final speedTarget = [0.5, 2.0, 2.0, 2.0][profile];

    // Trajectory smoothness: how consistent consecutive accel-delta directions
    // are. Constant-direction motion → traj near 1. Random noise → traj near 0.
    // Keep this above 0.85 in all profiles so Reach's traj check is happy;
    // we steer Manipulation FAIL via the timestep instead (see timeStepMs).
    final trajSmoothness = [0.97, 0.97, 0.97, 0.97][profile];

    // Time between samples in ms. Default 50ms → 100 samples = 5s, which
    // satisfies Manipulation's `duration<6` rule. Profile 2 stretches to
    // 70ms → ~7s, which trips Manipulation while leaving Reach untouched.
    final timeStepMs = [50, 50, 70, 50][profile];

    // flex/force baselines.
    //   Grasp passes when force>50 AND flex>40.
    //   Release passes when force<20 AND flex<20.
    // Profile 1 sits low (Grasp fails, Release passes); profile 3 sits high
    // (Grasp passes, Release fails).
    final flexBase = [10.0, 10.0, 45.0, 55.0][profile];
    final fsrBase = [10.0, 10.0, 55.0, 60.0][profile];

    // Build a continuous accel trajectory. We keep a slowly-rotating direction
    // vector and step the accel along it, so consecutive deltas point the same
    // way (high trajectory) for strong profiles and randomly (low) for weak.
    double dirAngle = rng.nextDouble() * 2 * pi;
    double prevAx = speedTarget * cos(dirAngle);
    double prevAy = speedTarget * sin(dirAngle);
    double prevAz = 0;

    final samples = <Map<String, num>>[];
    for (var i = 0; i < 100; i++) {
      // Slowly drift the direction so consecutive accel deltas point the same
      // way (high trajectory) for strong profiles. Weak profiles get added
      // jitter on top so the deltas randomize.
      dirAngle +=
          0.04 + (rng.nextDouble() * 2 - 1) * (1 - trajSmoothness) * 0.6;
      final stepMag = speedTarget * (0.95 + rng.nextDouble() * 0.1);
      prevAx = stepMag * cos(dirAngle);
      prevAy = stepMag * sin(dirAngle);
      prevAz = 0.3 * sin(dirAngle * 2);
      // Add small noise scaled by (1-smoothness) so weak profiles get noisy
      // deltas but strong profiles stay smooth.
      prevAx += (rng.nextDouble() * 2 - 1) * (1 - trajSmoothness) * speedTarget;
      prevAy += (rng.nextDouble() * 2 - 1) * (1 - trajSmoothness) * speedTarget;

      // Reach-and-return arc on gx so rom integrates to a clear range.
      final gx =
          gxAmplitude * (i < 50 ? 1 : -1) * (0.85 + rng.nextDouble() * 0.3);

      samples.add({
        // sample spacing — 50ms in normal profiles, 70ms in the
        // Manipulation-fail profile so the batch spans >6s.
        'time': i * timeStepMs,
        // flex sensors: 0-90° range (finger bend angle) — integer
        'flex1': (flexBase + rng.nextDouble() * 6 - 3).round().clamp(0, 90),
        'flex2': (flexBase + rng.nextDouble() * 6 - 3).round().clamp(0, 90),
        // FSR sensors: 0-100 force percentage — integer
        'fsr1': (fsrBase + rng.nextDouble() * 6 - 3).round().clamp(0, 100),
        'fsr2': (fsrBase + rng.nextDouble() * 6 - 3).round().clamp(0, 100),
        // EMG: ~300 baseline with variation (matches firmware range)
        'emg': (250 + rng.nextDouble() * 100).round(),
        // Accel/gyro are floats in g and °/s respectively, matching the
        // units assess_logic.py expects. Rounding to int (as we did before)
        // collapsed prevAz≈0.3 to 0 and snapped speed/trajectory away from
        // the assessment windows, which is why every session was failing
        // Reach. See QUESTIONS.md for the diagnosis.
        'ax': prevAx,
        'ay': prevAy,
        'az': prevAz,
        'gx': gx,
        'gy': rng.nextDouble() * 20 - 10,
        'gz': rng.nextDouble() * 20 - 10,
      });
    }

    final body = jsonEncode({
      'device_id': deviceId,
      'data': samples,
      'force_score': true,
    });

    http.Response response;
    try {
      response = await _client.post(
        Uri.parse('$apiBaseUrl/ingest'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
    } on Exception {
      // Retry once — Lambda cold-starts can cause the connection to be dropped
      // before the response headers arrive (CloudFront idle timeout ~15s).
      response = await _client.post(
        Uri.parse('$apiBaseUrl/ingest'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException('Simulate glove failed: ${response.statusCode}');
    }
  }

  Future<String> getVideoUploadUrl(String sessionId) => _network(() async {
    final response = await _client.post(
      Uri.parse('$apiBaseUrl/sessions/$sessionId/video-upload-url'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw ApiException('Failed to get upload URL: ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['upload_url'] as String;
  });

  Future<void> redoAssessment(String sessionId) => _network(() async {
    final response = await _client.post(
      Uri.parse('$apiBaseUrl/sessions/$sessionId/redo-assessment'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw ApiException(
        'Failed to restart assessment: ${response.statusCode}',
      );
    }
  });

  Future<void> deleteSession(String sessionId) => _network(() async {
    final response = await _client.delete(
      Uri.parse('$apiBaseUrl/sessions/$sessionId'),
    );
    if (response.statusCode != 200) {
      throw ApiException('Failed to delete session: ${response.statusCode}');
    }
  });
}
