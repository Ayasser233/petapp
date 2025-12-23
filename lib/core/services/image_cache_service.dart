import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Service to manage image cache clearing
class ImageCacheService extends GetxService {
  static ImageCacheService get instance => Get.find<ImageCacheService>();

  /// Clear all cached images
  Future<void> clearAllImageCache() async {
    try {
      debugPrint('🗑️ Clearing all image cache...');

      // Clear Flutter's image cache
      imageCache.clear();
      imageCache.clearLiveImages();

      debugPrint('✅ Image cache cleared successfully');

      // Show success message
      Get.snackbar(
        'Cache Cleared',
        'All cached images have been cleared',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      debugPrint('❌ Failed to clear image cache: $e');
      Get.snackbar(
        'Error',
        'Failed to clear image cache',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  /// Clear cache for a specific image URL
  Future<void> clearImageCacheForUrl(String imageUrl) async {
    try {
      debugPrint('🗑️ Clearing cache for image: $imageUrl');

      // Evict specific image from cache
      await imageCache.evict(NetworkImage(imageUrl));

      debugPrint('✅ Image cache cleared for: $imageUrl');
    } catch (e) {
      debugPrint('❌ Failed to clear cache for image: $e');
    }
  }

  /// Clear cache for multiple image URLs
  Future<void> clearImageCacheForUrls(List<String> imageUrls) async {
    try {
      debugPrint('🗑️ Clearing cache for ${imageUrls.length} images...');

      for (final url in imageUrls) {
        await imageCache.evict(NetworkImage(url));
      }

      debugPrint('✅ Image cache cleared for ${imageUrls.length} images');
    } catch (e) {
      debugPrint('❌ Failed to clear cache for images: $e');
    }
  }

  /// Get current cache size info
  int get currentCacheSize => imageCache.currentSize;

  /// Get maximum cache size
  int get maximumCacheSize => imageCache.maximumSize;

  /// Get current cache size in bytes
  int get currentCacheSizeBytes => imageCache.currentSizeBytes;

  /// Get maximum cache size in bytes
  int get maximumCacheSizeBytes => imageCache.maximumSizeBytes;

  /// Check if cache is full
  bool get isCacheFull => currentCacheSize >= maximumCacheSize;

  /// Get cache usage percentage
  double get cacheUsagePercentage {
    if (maximumCacheSize == 0) return 0.0;
    return (currentCacheSize / maximumCacheSize) * 100;
  }

  /// Print cache statistics
  void printCacheStats() {
    debugPrint('📊 Image Cache Statistics:');
    debugPrint('   Current Size: $currentCacheSize images');
    debugPrint('   Maximum Size: $maximumCacheSize images');
    debugPrint('   Current Size (Bytes): ${_formatBytes(currentCacheSizeBytes)}');
    debugPrint('   Maximum Size (Bytes): ${_formatBytes(maximumCacheSizeBytes)}');
    debugPrint('   Usage: ${cacheUsagePercentage.toStringAsFixed(1)}%');
    debugPrint('   Is Full: $isCacheFull');
  }

  /// Format bytes to human-readable format
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Configure image cache settings
  void configureCacheSettings({
    int? maximumSize,
    int? maximumSizeBytes,
  }) {
    if (maximumSize != null) {
      imageCache.maximumSize = maximumSize;
      debugPrint('📝 Image cache maximum size set to: $maximumSize images');
    }

    if (maximumSizeBytes != null) {
      imageCache.maximumSizeBytes = maximumSizeBytes;
      debugPrint('📝 Image cache maximum size (bytes) set to: ${_formatBytes(maximumSizeBytes)}');
    }
  }
}

