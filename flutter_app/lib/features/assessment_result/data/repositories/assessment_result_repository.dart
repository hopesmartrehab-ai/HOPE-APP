import 'package:dio/dio.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/network_services/web_constant.dart';
import '../../domain/entities/assessment_result.dart';
import '../models/assessment_result_model.dart';

/// Raised when the latest assessment session could not be read.
///
/// [message] is technical detail for logs; the UI shows a localized message of
/// its own.
class AssessmentResultException implements Exception {
  const AssessmentResultException(this.message);

  final String message;

  @override
  String toString() => 'AssessmentResultException: $message';
}

/// Reads finalized assessment sessions from the HOPE assessment backend.
class AssessmentResultRepository {
  const AssessmentResultRepository();

  static const String latestSessionPath = '/api/v1/sessions/latest';

  /// Returns the most recently received finalized session.
  ///
  /// The endpoint is global rather than per-patient, so the caller is expected
  /// to check [AssessmentResult.receivedAtUtc] to confirm the record belongs to
  /// the session that just finished.
  Future<AssessmentResult> fetchLatest() async {
    try {
      final response = await apiService
          .client(requireAuth: false)
          .get<Map<String, dynamic>>(
            '${WebConstant.hopeBaseUrl}$latestSessionPath',
            options: Options(
              headers: const {
                WebConstant.hopePrototypeKeyHeader: WebConstant.hopePrototypeKey,
              },
            ),
          );

      final data = response.data;
      if (data == null) {
        throw const AssessmentResultException('Empty response body');
      }

      return AssessmentResultModel.fromJson(data);
    } on DioException catch (error) {
      throw AssessmentResultException(_describe(error));
    }
  }

  String _describe(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null) {
      return 'Request failed with status $statusCode';
    }
    return error.message ?? error.type.name;
  }
}
