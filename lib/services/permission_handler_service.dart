import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  /// Request storage permission for Android
  /// Returns true if permission is granted, false otherwise
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();

    if (status.isDenied) {
      // Permission denied
      return false;
    } else if (status.isGranted) {
      // Permission granted
      return true;
    } else if (status.isDenied) {
      // Permission denied
      return false;
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, open app settings
      openAppSettings();
      return false;
    }
    return false;
  }

  /// Request manage external storage permission (for Android 11+)
  static Future<bool> requestManageExternalStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }

  /// Request read external storage permission
  static Future<bool> requestReadExternalStoragePermission() async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }

  /// Request all necessary permissions for file operations
  static Future<bool> requestFilePermissions() async {
    // Try to request manage external storage first (Android 11+)
    final manageStatus = await requestManageExternalStoragePermission();

    if (manageStatus) {
      return true;
    }

    // Fallback to storage permission for older Android versions
    return requestStoragePermission();
  }

  /// Check if storage permission is already granted
  static Future<bool> isStoragePermissionGranted() async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  /// Check if manage external storage permission is already granted
  static Future<bool> isManageExternalStoragePermissionGranted() async {
    final status = await Permission.manageExternalStorage.status;
    return status.isGranted;
  }

  /// Open app settings for manual permission granting
  static void openSettings() {
    openAppSettings();
  }
}
