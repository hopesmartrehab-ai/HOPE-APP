import 'dart:developer' as dev;
import 'package:talker/talker.dart';
import 'debug_log_entry.dart';

// ─── Formatting helpers ──────────────────────────────────────────────────────

// ─── HTTP log formatter ──────────────────────────────────────────────────────

String _formatHttp(HttpLogEntry e) {
  const w = 72;
  const dash = '─';

  final buf = StringBuffer();
  final isError = !e.isSuccess;
  final tl = isError ? '╔' : '┌';
  final bl = isError ? '╚' : '└';
  final lr = isError ? '║' : '│';
  final div = isError ? '╠' : '├';
  final tr = isError ? '╗' : '┐';
  final br = isError ? '╝' : '┘';
  final divR = isError ? '╣' : '┤';

  String line(String l, String r) => '$l${dash * w}$r';
  String row(String text) {
    final pad = w - 1 - text.length;
    return '$lr $text${pad > 0 ? ' ' * pad : ''}$tr';
  }
  String section(String title) =>
      '$div${dash * (w ~/ 2 - title.length ~/ 2 - 1)} $title ${dash * (w ~/ 2 - (title.length + 1) ~/ 2 - 1)}$divR';

  final time = _fmtTime(e.timestamp);
  final dur = e.duration != null ? '${e.duration!.inMilliseconds}ms' : '—';
  final status = e.statusCode != null
      ? '${e.statusCode}${e.reasonPhrase != null ? ' ${e.reasonPhrase}' : ''}'
      : 'NETWORK ERROR';

  buf.writeln(line(tl, tr));
  buf.writeln(row('HTTP  ${e.method.padRight(7)} $status  •  $dur  •  $time'));
  buf.writeln(row('URL   ${e.url}'));

  // Request
  buf.writeln(section('REQUEST'));
  if (e.requestHeaders.isNotEmpty) {
    buf.writeln(row('Headers:'));
    e.requestHeaders.forEach((k, v) => buf.writeln(row('  $k: $v')));
  }
  final reqBody = e.prettyRequestBody ?? '(empty)';
  buf.writeln(row('Body:'));
  for (final l in reqBody.split('\n')) {
    buf.writeln(row('  $l'));
  }

  // Response
  buf.writeln(section(e.error != null ? 'ERROR' : 'RESPONSE'));
  if (e.error != null) {
    buf.writeln(row('  ${e.error}'));
    if (e.stackTrace != null) {
      for (final l in e.stackTrace.toString().split('\n').take(5)) {
        buf.writeln(row('  $l'));
      }
    }
  } else {
    if (e.responseHeaders != null && e.responseHeaders!.isNotEmpty) {
      buf.writeln(row('Headers:'));
      e.responseHeaders!.forEach((k, v) => buf.writeln(row('  $k: $v')));
    }
    final resBody = e.prettyResponseBody ?? '(empty)';
    buf.writeln(row('Body:'));
    for (final l in resBody.split('\n')) {
      buf.writeln(row('  $l'));
    }
  }

  buf.write(line(bl, br));
  return buf.toString();
}

String _fmtTime(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  final s = dt.second.toString().padLeft(2, '0');
  final ms = dt.millisecond.toString().padLeft(3, '0');
  return '$h:$m:$s.$ms';
}

// ─── Talker custom types (kept for TalkerScreen in-app display) ──────────────

class HttpTalkerLog extends TalkerLog {
  final HttpLogEntry entry;

  HttpTalkerLog(this.entry)
      : super(
          _formatHttp(entry),
          title: 'HTTP',
          logLevel: entry.isSuccess ? LogLevel.debug : LogLevel.error,
        );

  @override
  AnsiPen get pen => AnsiPen()..white();
}

class StateTalkerLog extends TalkerLog {
  StateTalkerLog(String from, String to)
      : super(
          '[${'─' * 3} STATE ${'─' * 3}]  $from  →  $to',
          title: 'STATE',
          logLevel: LogLevel.info,
        );

  @override
  AnsiPen get pen => AnsiPen()..white();
}

// ─── AppLogger ───────────────────────────────────────────────────────────────

/// Singleton logger.
///
/// - Console output: dart:developer log() — renders boxes cleanly, no ANSI garbage.
/// - In-app panel: Talker history (colours disabled so TalkerScreen also stays clean).
class AppLogger {
  static final AppLogger instance = AppLogger._();

  late final Talker _talker;

  AppLogger._() {
    _talker = Talker(
      settings: TalkerSettings(
        enabled: true,
        useConsoleLogs: false, // we drive console output ourselves via dev.log
      ),
    );
  }

  Talker get talker => _talker;

  void logHttp(HttpLogEntry entry) {
    final msg = _formatHttp(entry);
    // Single dev.log call so the box prints as one unbroken block
    dev.log(msg, name: 'HTTP', level: entry.isSuccess ? 500 : 900);
    _talker.logCustom(HttpTalkerLog(entry));
  }

  void logStateChange(String from, String to) {
    final time = _fmtTime(DateTime.now());
    dev.log(
      '┌${'─' * 62}┐\n'
      '│  STATE  $from  →  $to${' ' * (50 - from.length - to.length > 0 ? 50 - from.length - to.length : 0)}  $time  │\n'
      '└${'─' * 62}┘',
      name: 'STATE',
    );
    _talker.logCustom(StateTalkerLog(from, to));
  }

  void logError(String message, [Object? error, StackTrace? stackTrace]) {
    dev.log(message, name: 'ERROR', level: 1000, error: error, stackTrace: stackTrace);
    _talker.error(message, error, stackTrace);
  }

  void logInfo(String message) {
    dev.log(message, name: 'INFO');
    _talker.info(message);
  }

  void logDebug(String message) {
    dev.log(message, name: 'DEBUG', level: 300);
    _talker.debug(message);
  }

  void clear() {
    _talker.cleanHistory();
  }
}
