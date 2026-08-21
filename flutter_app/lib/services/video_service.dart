import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class VideoService {
  final http.Client _client;

  VideoService(this._client);

  Future<void> uploadVideo(String sessionId, File videoFile) async {
    // Note: We need to get the upload URL, but we can't call ApiService directly
    // since it's now instance-based. The caller (SessionProvider) should handle this.
    // For now, we'll accept the upload URL as a parameter.
    throw UnimplementedError('Use uploadVideoWithUrl instead');
  }

  Future<void> uploadVideoWithUrl(String uploadUrl, File videoFile) async {
    final bytes = await videoFile.readAsBytes();
    final response = await _client.put(
      Uri.parse(uploadUrl),
      headers: {'Content-Type': 'video/mp4'},
      body: bytes,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ApiException('Failed to upload video: ${response.statusCode}');
    }
  }
}
