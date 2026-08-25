// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';

// import '../../di/service_locator.dart';
// import '../../styles/app_colors.dart';

// class ImageService {
//   final ImagePicker _picker = ImagePicker();

//   /// Picks a single image, compresses it, uploads it, and returns
//   /// the local compressed [File] and the remote [url].
//   ///
//   /// Returns `null` if the user cancels at any step.
//   Future<(File localFile, String url)?> pickAndUpload({
//     required BuildContext context,
//     Function(String)? onError,
//   }) async {
//     final source = await _showSourcePicker(context);
//     if (source == null) return null;

//     final picked = await _picker.pickImage(source: source);
//     if (picked == null) return null;

//     final compressed = await _compress(picked.path);
//     if (compressed == null) {
//       onError?.call('Image compression failed');
//       return null;
//     }

//     final uploadResult = await uploadRepo.uploadFiles(
//       filePaths: [compressed.path],
//       fileNames: [p.basename(compressed.path)],
//     );

//     return uploadResult.fold((failure) {
//       onError?.call(failure.errorMessage);
//       return null;
//     }, (models) => models.isNotEmpty ? (compressed, models.first.url) : null);
//   }

//   /// Picks multiple images, compresses them, uploads all at once,
//   /// and returns a list of (localFile, remoteUrl) pairs.
//   ///
//   /// Returns an empty list if the user cancels.
//   Future<List<(File localFile, String url)>> pickMultipleAndUpload({
//     required BuildContext context,
//     Function(String)? onError,
//   }) async {
//     final picked = await _picker.pickMultiImage();
//     if (picked.isEmpty) return [];

//     final compressed = <File>[];
//     for (final xFile in picked) {
//       final file = await _compress(xFile.path);
//       if (file == null) {
//         onError?.call('Image compression failed');
//         return [];
//       }
//       compressed.add(file);
//     }

//     final uploadResult = await uploadRepo.uploadFiles(
//       filePaths: compressed.map((f) => f.path).toList(),
//       fileNames: compressed.map((f) => p.basename(f.path)).toList(),
//     );

//     return uploadResult.fold((failure) {
//       onError?.call(failure.errorMessage);
//       return [];
//     }, (models) {
//       final results = <(File, String)>[];
//       for (int i = 0; i < models.length && i < compressed.length; i++) {
//         results.add((compressed[i], models[i].url));
//       }
//       return results;
//     });
//   }

//   /// Compresses [sourcePath] to JPEG with 85% quality and max 1080px on the
//   /// longest side. Returns the compressed [File], or `null` on failure.
//   Future<File?> _compress(String sourcePath) async {
//     final dir = await getTemporaryDirectory();
//     final name = '${p.basenameWithoutExtension(sourcePath)}_compressed.jpg';
//     final targetPath = p.join(dir.path, name);

//     final result = await FlutterImageCompress.compressAndGetFile(
//       sourcePath,
//       targetPath,
//       quality: 85,
//       minWidth: 1080,
//       minHeight: 1080,
//       format: CompressFormat.jpeg,
//     );

//     return result == null ? null : File(result.path);
//   }

//   Future<ImageSource?> _showSourcePicker(BuildContext context) {
//     return showModalBottomSheet<ImageSource>(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (ctx) => SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(bottom: 12),
//                 decoration: BoxDecoration(
//                   color: ctx.buttomSheetTopColor,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt_outlined),
//                 title: const Text('Camera'),
//                 onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library_outlined),
//                 title: const Text('Gallery'),
//                 onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
