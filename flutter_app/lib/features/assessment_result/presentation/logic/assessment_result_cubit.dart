import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/assessment_result_repository.dart';
import '../../domain/entities/assessment_result.dart';

part 'assessment_result_state.dart';

/// Loads the finalized assessment session for the results screens.
class AssessmentResultCubit extends Cubit<AssessmentResultState> {
  AssessmentResultCubit({AssessmentResultRepository? repository})
    : _repository = repository ?? const AssessmentResultRepository(),
      super(const AssessmentResultInitial());

  final AssessmentResultRepository _repository;

  /// How many times to ask for a session recorded after [loadLatest] began.
  static const int _maxAttempts = 5;

  static const Duration _retryDelay = Duration(seconds: 2);

  /// Fetches the latest session, retrying while the backend has not yet
  /// received the one that just finished.
  ///
  /// `sessions/latest` is global rather than per-patient, and a record can lag
  /// the game's own finish by minutes, so a single immediate call would often
  /// return the *previous* session. Anything received before this call started
  /// is therefore treated as not-yet-arrived and retried; after the final
  /// attempt the newest record available is shown, flagged as stale, since a
  /// slightly old result beats an error screen.
  Future<void> loadLatest() async {
    emit(const AssessmentResultLoading());

    final sessionStartedAt = DateTime.now().toUtc();

    AssessmentResult? lastSeen;
    AssessmentResultException? lastFailure;

    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      try {
        final result = await _repository.fetchLatest();
        lastSeen = result;

        if (!result.receivedAtUtc.isBefore(sessionStartedAt)) {
          if (isClosed) return;
          emit(AssessmentResultSuccess(result));
          return;
        }

        debugPrint(
          '⏳ Assessment result not received yet '
          '(attempt $attempt/$_maxAttempts, server has '
          '${result.receivedAtUtc.toIso8601String()})',
        );
      } on AssessmentResultException catch (error) {
        lastFailure = error;
        debugPrint('❌ Assessment result fetch failed: ${error.message}');
      }

      if (attempt == _maxAttempts) break;

      await Future<void>.delayed(_retryDelay);
      if (isClosed) return;
    }

    if (isClosed) return;

    // Out of attempts. A record we did manage to read is still worth showing,
    // flagged as stale; only give up when every attempt failed.
    if (lastSeen != null) {
      debugPrint(
        '⚠️ Assessment result is stale: server received '
        '${lastSeen.receivedAtUtc.toIso8601String()}, but the finished session '
        'started at ${sessionStartedAt.toIso8601String()}',
      );
      emit(AssessmentResultSuccess(lastSeen, isStale: true));
      return;
    }

    emit(AssessmentResultFailure(lastFailure?.message ?? 'Unknown error'));
  }

  /// Re-runs the load after a failure.
  Future<void> retry() => loadLatest();
}
