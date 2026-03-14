import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 缓存服务
class CacheService {
  /// 获取缓存大小（字节）
  static Future<int> getCacheSize() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      return await _getTotalSize(tempDir);
    } catch (e) {
      return 0;
    }
  }

  /// 获取目录总大小
  static Future<int> _getTotalSize(Directory dir) async {
    int total = 0;
    try {
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          total += await entity.length();
        } else if (entity is Directory) {
          total += await _getTotalSize(entity);
        }
      }
    } catch (e) {
      // 忽略错误
    }
    return total;
  }

  /// 格式化缓存大小
  static String formatCacheSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  /// 清除缓存
  static Future<bool> clearCache() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      await _deleteDirectoryContents(tempDir);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 删除目录内容但保留目录本身
  static Future<void> _deleteDirectoryContents(Directory dir) async {
    try {
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          await entity.delete();
        } else if (entity is Directory) {
          await entity.delete(recursive: true);
        }
      }
    } catch (e) {
      // 忽略错误
    }
  }
}
