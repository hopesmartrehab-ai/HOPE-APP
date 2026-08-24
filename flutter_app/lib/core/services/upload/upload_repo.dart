import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../network_services/api_service_failure.dart';
import 'upload_model.dart';

abstract class UploadRepo {
  /// Upload one or more files from local [filePaths].
  /// Each entry is a `{filePath, fileName, mimeType?}` map.
  Future<Either<ServerFailure, List<UploadModel>>> uploadFiles({
    required List<String> filePaths,
    required List<String> fileNames,
    List<String?>? mimeTypes,
  });

  /// Upload one or more files from raw bytes.
  Future<Either<ServerFailure, List<UploadModel>>> uploadBytesList({
    required List<Uint8List> bytesList,
    required List<String> fileNames,
    List<String?>? mimeTypes,
  });
}
