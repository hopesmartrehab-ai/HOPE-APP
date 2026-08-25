import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'debug_log_entry.dart';

/// In-memory storage for debug logs. Holds the last N entries.
class DebugLogStore extends ChangeNotifier {
  static const int maxHttpEntries = 200;
  static const int maxStateEntries = 100;

  final List<HttpLogEntry> _httpLogs = [];
  final List<StateChangeEvent> _stateLogs = [];

  /// All HTTP log entries (most recent first).
  UnmodifiableListView<HttpLogEntry> get httpLogs =>
      UnmodifiableListView(_httpLogs.reversed.toList());

  /// Only error HTTP log entries (most recent first).
  UnmodifiableListView<HttpLogEntry> get errorHttpLogs =>
      UnmodifiableListView(
        _httpLogs.reversed.where((e) => !e.isSuccess).toList(),
      );

  /// Only successful HTTP log entries (most recent first).
  UnmodifiableListView<HttpLogEntry> get successHttpLogs =>
      UnmodifiableListView(
        _httpLogs.reversed.where((e) => e.isSuccess).toList(),
      );

  /// All state change events (most recent first).
  UnmodifiableListView<StateChangeEvent> get stateLogs =>
      UnmodifiableListView(_stateLogs.reversed.toList());

  /// Add an HTTP log entry.
  void addHttpEntry(HttpLogEntry entry) {
    if (_httpLogs.length >= maxHttpEntries) {
      _httpLogs.removeAt(0);
    }
    _httpLogs.add(entry);
    notifyListeners();
  }

  /// Add a state change event.
  void addStateChange(StateChangeEvent event) {
    if (_stateLogs.length >= maxStateEntries) {
      _stateLogs.removeAt(0);
    }
    _stateLogs.add(event);
    notifyListeners();
  }

  /// Clear all logs.
  void clearAll() {
    _httpLogs.clear();
    _stateLogs.clear();
    notifyListeners();
  }

  /// Export all logs as a formatted JSON string.
  String exportJson() {
    return const JsonEncoder.withIndent('  ').convert({
      'exportTimestamp': DateTime.now().toIso8601String(),
      'httpLogs': _httpLogs.map((e) => e.toJson()).toList(),
      'stateLogs': _stateLogs.map((e) => e.toJson()).toList(),
    });
  }
}
