import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'permission_handler_service.dart';
import 'dart:typed_data';

class FileDownloadService {
  /// Download file to primary storage (Downloads folder)
  /// Returns true if download was successful, false otherwise
  static Future<bool> downloadFile({
    required String sourceFilePath,
    required String fileName,
  }) async {
    try {
      // Request necessary permissions
      final hasPermission =
          await PermissionHandlerService.requestFilePermissions();

      if (!hasPermission) {
        return false;
      }

      // Read the source file
      final sourceFile = File(sourceFilePath);

      if (!await sourceFile.exists()) {
        throw Exception('Source file does not exist');
      }

      final bytes = await sourceFile.readAsBytes();

      // Get file extension
      // ignore: unused_local_variable
      final fileExtension =
          fileName.contains('.') ? fileName.split('.').last : 'bin';

      // Determine destination directory and write file manually
      final destDirectory = await _getDownloadsDirectory();
      final destPath = '$destDirectory${Platform.pathSeparator}$fileName';
      final destFile = File(destPath);

      await destFile.create(recursive: true);
      await destFile.writeAsBytes(bytes);

      return await destFile.exists();
    } catch (e) {
      print('Download error: $e');
      return false;
    }
  }

  /// Download file from a local path to downloads folder with custom directory
  static Future<bool> downloadFileToCustomPath({
    required String sourceFilePath,
    required String fileName,
    String? customPath,
  }) async {
    try {
      // Request necessary permissions
      final hasPermission =
          await PermissionHandlerService.requestFilePermissions();

      if (!hasPermission) {
        return false;
      }

      // Read the source file
      final sourceFile = File(sourceFilePath);

      if (!await sourceFile.exists()) {
        throw Exception('Source file does not exist');
      }

      final bytes = await sourceFile.readAsBytes();

      // Determine destination directory
      final String destDirectory = customPath ?? await _getDownloadsDirectory();

      // Create directory if it doesn't exist
      final dir = Directory(destDirectory);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Create destination file
      final destFile = File('$destDirectory${Platform.pathSeparator}$fileName');
      await destFile.writeAsBytes(bytes);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get downloads directory path
  static Future<String> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      // For Android, use the external files directory (Downloads folder)
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        // Return parent directory to get access to shared storage
        return directory.parent.path;
      }
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }

    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Check if file exists at the given path
  static Future<bool> fileExists(String filePath) async {
    final file = File(filePath);
    return await file.exists();
  }

  /// Save raw bytes directly to the Downloads directory and return saved file path.
  /// Returns null on failure.
  static Future<String?> saveBytesToDownloads(
      Uint8List bytes, String fileName) async {
    try {
      final hasPermission =
          await PermissionHandlerService.requestFilePermissions();
      if (!hasPermission) return null;

      final destDirectory = await _getDownloadsDirectory();
      final destPath = '${destDirectory}${Platform.pathSeparator}$fileName';
      final destFile = File(destPath);
      await destFile.create(recursive: true);
      await destFile.writeAsBytes(bytes);
      return await destFile.exists() ? destFile.path : null;
    } catch (e) {
      print('saveBytesToDownloads error: $e');
      return null;
    }
  }

  /// Get file size in bytes
  static Future<int?> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
    } catch (e) {
      print('Error getting file size: $e');
    }
    return null;
  }

  /// Format bytes to human-readable size
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes.toString().length / 3).ceil();
    return '${(bytes / pow(1024, i - 1)).round()} ${suffixes[i - 1]}';
  }
}

double pow(double base, int exponent) {
  double result = 1.0;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}
