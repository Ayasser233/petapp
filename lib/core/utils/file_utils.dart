import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FileUtils {
  /// Compresses an image file if it's over a certain size
  static Future<File> compressImage(File file, {int quality = 70}) async {
    // Only compress if it's an image
    final extension = p.extension(file.path).toLowerCase();
    if (!['.jpg', '.jpeg', '.png', '.webp'].contains(extension)) {
      return file;
    }

    // Don't compress if file is already small (e.g., < 300KB)
    final size = await file.length();
    if (size < 300 * 1024) {
      return file;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath = p.join(
        tempDir.path,
        "comp_${DateTime.now().millisecondsSinceEpoch}${extension == '.png' ? '.jpg' : extension}",
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
      );

      if (result != null) {
        debugPrint('Image compressed from ${size ~/ 1024}KB to ${File(result.path).lengthSync() ~/ 1024}KB');
        return File(result.path);
      }
    } catch (e) {
      debugPrint('Compression error: $e');
    }

    return file;
  }
}
