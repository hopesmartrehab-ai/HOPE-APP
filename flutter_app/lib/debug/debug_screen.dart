import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../config.dart';
import 'app_logger.dart';
import 'debug_log_entry.dart';
import 'debug_log_store.dart';

/// Full-screen debug panel with 3 tabs: Logs (Talker), Requests (HTTP), Info.
class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _httpFilter = 'all'; // 'all', 'success', 'errors'

  // Device/app info (loaded once)
  String _appVersion = '';
  String _deviceInfo = '';
  String _platform = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfo = DeviceInfoPlugin();

    String deviceStr = '';
    String platformStr = '';

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      deviceStr = '${android.manufacturer} ${android.model}';
      platformStr = 'Android ${android.version.release}';
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      deviceStr = ios.model;
      platformStr = 'iOS ${ios.systemVersion}';
    } else {
      deviceStr = 'Unknown';
      platformStr = Platform.operatingSystem;
    }

    setState(() {
      _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
      _deviceInfo = deviceStr;
      _platform = platformStr;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Panel'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.teal,
          tabs: const [
            Tab(text: 'Logs'),
            Tab(text: 'Requests'),
            Tab(text: 'Info'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLogsTab(),
          _buildRequestsTab(),
          _buildInfoTab(),
        ],
      ),
    );
  }

  Widget _buildLogsTab() {
    return TalkerScreen(
      talker: AppLogger.instance.talker,
      theme: TalkerScreenTheme(
        backgroundColor: Colors.grey[900]!,
        cardColor: Colors.grey[850]!,
        textColor: Colors.white,
      ),
    );
  }

  Widget _buildRequestsTab() {
    return Consumer<DebugLogStore>(
      builder: (context, store, child) {
        final logs = _getFilteredLogs(store);

        return Column(
          children: [
            // Filter chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.grey[850],
              child: Row(
                children: [
                  _buildFilterChip('All', 'all', store),
                  const SizedBox(width: 8),
                  _buildFilterChip('2xx', 'success', store),
                  const SizedBox(width: 8),
                  _buildFilterChip('Errors', 'errors', store),
                ],
              ),
            ),
            // Request list
            Expanded(
              child: logs.isEmpty
                  ? Center(
                      child: Text(
                        'No HTTP requests logged',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        return _buildRequestCard(logs[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String filter, DebugLogStore store) {
    final isSelected = _httpFilter == filter;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _httpFilter = filter;
        });
      },
      selectedColor: Colors.teal,
      backgroundColor: Colors.grey[800],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[400],
      ),
    );
  }

  List<HttpLogEntry> _getFilteredLogs(DebugLogStore store) {
    switch (_httpFilter) {
      case 'success':
        return store.successHttpLogs.toList();
      case 'errors':
        return store.errorHttpLogs.toList();
      default:
        return store.httpLogs.toList();
    }
  }

  Widget _buildRequestCard(HttpLogEntry entry) {
    final statusColor = _getStatusColor(entry);

    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  entry.method,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  entry.statusCode?.toString() ?? 'ERR',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                entry.duration != null ? '${entry.duration!.inMilliseconds}ms' : '',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _truncateUrl(entry.url),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          children: [
            // Request details
            _buildExpandableSection(
              'Request Headers',
              entry.requestHeaders.entries
                  .map((e) => '${e.key}: ${e.value}')
                  .join('\n'),
            ),
            if (entry.requestBody != null && entry.requestBody!.isNotEmpty)
              _buildExpandableSection(
                'Request Body',
                entry.prettyRequestBody ?? entry.requestBody!,
              ),
            // Response details
            if (entry.responseHeaders != null && entry.responseHeaders!.isNotEmpty)
              _buildExpandableSection(
                'Response Headers',
                entry.responseHeaders!.entries
                    .map((e) => '${e.key}: ${e.value}')
                    .join('\n'),
              ),
            if (entry.responseBody != null && entry.responseBody!.isNotEmpty)
              _buildExpandableSection(
                'Response Body',
                entry.prettyResponseBody ?? entry.responseBody!,
              ),
            if (entry.error != null)
              _buildExpandableSection(
                'Error',
                entry.error.toString(),
              ),
            // Copy button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Copy as JSON'),
                onPressed: () => _copyEntry(entry),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.teal[300],
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(4),
            ),
            child: SelectableText(
              content,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(HttpLogEntry entry) {
    if (entry.isNetworkError || entry.isServerError) {
      return Colors.red;
    } else if (entry.isClientError) {
      return Colors.orange;
    } else if (entry.isRedirect) {
      return Colors.blue;
    } else if (entry.isSuccess) {
      return Colors.green;
    }
    return Colors.grey;
  }

  String _truncateUrl(String url) {
    final uri = Uri.parse(url);
    return uri.path;
  }

  void _copyEntry(HttpLogEntry entry) {
    final json = const JsonEncoder.withIndent('  ').convert(entry.toJson());
    Clipboard.setData(ClipboardData(text: json));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied request to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget _buildInfoTab() {
    return Consumer<DebugLogStore>(
      builder: (context, store, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection('App Info', [
                _buildInfoRow('Version', _appVersion),
                _buildInfoRow('Package', 'hope_app'),
              ]),
              const SizedBox(height: 16),
              _buildInfoSection('Device Info', [
                _buildInfoRow('Device', _deviceInfo),
                _buildInfoRow('Platform', _platform),
              ]),
              const SizedBox(height: 16),
              _buildInfoSection('Config', [
                _buildInfoRow('API Base URL', apiBaseUrl),
                _buildInfoRow('Default Device ID', defaultDeviceId),
              ]),
              const SizedBox(height: 16),
              _buildInfoSection('Stats', [
                _buildInfoRow('HTTP Requests', '${store.httpLogs.length}'),
                _buildInfoRow('State Changes', '${store.stateLogs.length}'),
              ]),
              const SizedBox(height: 24),
              // Action buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.file_download),
                  label: const Text('Export All Logs as JSON'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _exportAll(store),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Clear All Logs'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _clearAll(store),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exportAll(DebugLogStore store) {
    final json = store.exportJson();
    Clipboard.setData(ClipboardData(text: json));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exported all logs to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearAll(DebugLogStore store) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Logs?'),
        content: const Text('This will delete all stored HTTP and state logs.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              store.clearAll();
              AppLogger.instance.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logs cleared'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

