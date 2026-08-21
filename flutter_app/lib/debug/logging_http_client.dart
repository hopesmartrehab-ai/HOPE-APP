import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_logger.dart';
import 'debug_log_entry.dart';
import 'debug_log_store.dart';

/// A custom HTTP client that extends BaseClient to intercept all requests.
/// Logs timing, request details, and response details to both console and DebugLogStore.
class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;
  final DebugLogStore _store;

  LoggingHttpClient({
    http.Client? inner,
    required DebugLogStore store,
  })  : _inner = inner ?? http.Client(),
        _store = store;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final stopwatch = Stopwatch()..start();
    final timestamp = DateTime.now();
    final id = timestamp.microsecondsSinceEpoch.toString();

    // Extract request body (only http.Request has body, MultipartRequest is different)
    String? requestBody;
    if (request is http.Request && request.body.isNotEmpty) {
      requestBody = request.body;
    } else if (request is http.MultipartRequest) {
      requestBody = '[multipart form data]';
    }

    final requestHeaders = Map<String, String>.from(request.headers);

    try {
      final response = await _inner.send(request);

      // Consume the stream to read response body
      final bytes = await response.stream.toBytes();
      stopwatch.stop();

      // Decode response body with malformed fallback for binary content
      final responseBody = utf8.decode(bytes, allowMalformed: true);

      final entry = HttpLogEntry(
        id: id,
        timestamp: timestamp,
        method: request.method,
        url: request.url.toString(),
        requestHeaders: requestHeaders,
        requestBody: requestBody,
        statusCode: response.statusCode,
        reasonPhrase: response.reasonPhrase,
        responseHeaders: Map<String, String>.from(response.headers),
        responseBody: responseBody,
        duration: stopwatch.elapsed,
      );

      // Log to console via AppLogger
      AppLogger.instance.logHttp(entry);

      // Store for in-app debug panel
      _store.addHttpEntry(entry);

      // Reconstruct the StreamedResponse with the consumed bytes
      return http.StreamedResponse(
        Stream.value(bytes),
        response.statusCode,
        headers: response.headers,
        reasonPhrase: response.reasonPhrase,
        contentLength: bytes.length,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        request: response.request,
      );
    } catch (e, st) {
      stopwatch.stop();

      final entry = HttpLogEntry(
        id: id,
        timestamp: timestamp,
        method: request.method,
        url: request.url.toString(),
        requestHeaders: requestHeaders,
        requestBody: requestBody,
        statusCode: null,
        duration: stopwatch.elapsed,
        error: e,
        stackTrace: st,
      );

      AppLogger.instance.logHttp(entry);
      _store.addHttpEntry(entry);

      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
