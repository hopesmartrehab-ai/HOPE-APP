import 'dart:convert';

/// Represents a single HTTP request/response transaction for logging.
class HttpLogEntry {
  final String id;
  final DateTime timestamp;
  final String method;
  final String url;
  final Map<String, String> requestHeaders;
  final String? requestBody;
  final int? statusCode;
  final String? reasonPhrase;
  final Map<String, String>? responseHeaders;
  final String? responseBody;
  final Duration? duration;
  final Object? error;
  final StackTrace? stackTrace;

  HttpLogEntry({
    required this.id,
    required this.timestamp,
    required this.method,
    required this.url,
    required this.requestHeaders,
    this.requestBody,
    this.statusCode,
    this.reasonPhrase,
    this.responseHeaders,
    this.responseBody,
    this.duration,
    this.error,
    this.stackTrace,
  });

  bool get isSuccess =>
      statusCode != null && statusCode! >= 200 && statusCode! < 300;
  bool get isRedirect =>
      statusCode != null && statusCode! >= 300 && statusCode! < 400;
  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;
  bool get isServerError =>
      statusCode != null && statusCode! >= 500;
  bool get isNetworkError => statusCode == null;

  String get statusCategory {
    if (isNetworkError) return 'error';
    if (isSuccess) return 'success';
    if (isRedirect) return 'redirect';
    if (isClientError) return 'client_error';
    if (isServerError) return 'server_error';
    return 'unknown';
  }

  String? get prettyRequestBody {
    if (requestBody == null) return null;
    return _tryPrettyJson(requestBody!);
  }

  String? get prettyResponseBody {
    if (responseBody == null) return null;
    return _tryPrettyJson(responseBody!);
  }

  static String? _tryPrettyJson(String input) {
    try {
      final parsed = jsonDecode(input);
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(parsed);
    } catch (_) {
      return input;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'method': method,
      'url': url,
      'requestHeaders': requestHeaders,
      'requestBody': requestBody,
      'statusCode': statusCode,
      'reasonPhrase': reasonPhrase,
      'responseHeaders': responseHeaders,
      'responseBody': responseBody,
      'durationMs': duration?.inMilliseconds,
      'error': error?.toString(),
      'stackTrace': stackTrace?.toString(),
    };
  }
}

/// Represents a state transition event for logging.
class StateChangeEvent {
  final String from;
  final String to;
  final DateTime timestamp;
  final String? context;

  StateChangeEvent({
    required this.from,
    required this.to,
    required this.timestamp,
    this.context,
  });

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'timestamp': timestamp.toIso8601String(),
      'context': context,
    };
  }
}
