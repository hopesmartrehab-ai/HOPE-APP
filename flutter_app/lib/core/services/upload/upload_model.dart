class UploadModel {
  final String url;
  final String originalName;
  final int size;
  final String mimeType;

  UploadModel({
    required this.url,
    required this.originalName,
    required this.size,
    required this.mimeType,
  });

  factory UploadModel.fromJson(Map<String, dynamic> json) {
    return UploadModel(
      url: json['url'] as String,
      originalName: json['originalName'] as String,
      size: json['size'] as int,
      mimeType: json['mimeType'] as String,
    );
  }

  static List<UploadModel> fromJsonList(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>;
    return data
        .map((e) => UploadModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
