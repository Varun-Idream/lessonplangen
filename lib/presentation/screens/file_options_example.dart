import 'package:flutter/material.dart';
import 'package:lessonplan/services/file_download_service.dart';
import 'package:lessonplan/presentation/screens/file_viewer_screen.dart';

/// Example usage of file viewer and download functionality
///
/// This file demonstrates how to:
/// 1. Request permissions for file access
/// 2. View files in a webview
/// 3. Download files to the device storage
///
/// Usage:
/// Navigate to this screen and tap the buttons to test the functionality

class FileOptionsScreen extends StatefulWidget {
  final String filePath;
  final String fileName;

  const FileOptionsScreen({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  @override
  State<FileOptionsScreen> createState() => _FileOptionsScreenState();
}

class _FileOptionsScreenState extends State<FileOptionsScreen> {
  bool _isDownloading = false;

  /// Handle view file option
  void _handleViewFile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FileViewerScreen(
          filePath: widget.filePath,
          fileName: widget.fileName,
        ),
      ),
    );
  }

  /// Handle download file option
  void _handleDownloadFile() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final success = await FileDownloadService.downloadFile(
        sourceFilePath: widget.filePath,
        fileName: widget.fileName,
      );

      if (mounted) {
        setState(() {
          _isDownloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'File downloaded successfully to Downloads folder'
                  : 'Failed to download file. Please check permissions.',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Options'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'File: ${widget.fileName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _handleViewFile,
                icon: const Icon(Icons.visibility),
                label: const Text('View File'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isDownloading ? null : _handleDownloadFile,
                icon: _isDownloading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.download),
                label:
                    Text(_isDownloading ? 'Downloading...' : 'Download File'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper class for showing file actions in a dialog
class FileActionsDialog {
  static void show(
    BuildContext context, {
    required String filePath,
    required String fileName,
    VoidCallback? onViewPressed,
    VoidCallback? onDownloadPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Actions'),
        content: Text('What would you like to do with "$fileName"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onViewPressed?.call();
            },
            child: const Text('View'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDownloadPressed?.call();
            },
            child: const Text('Download'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
