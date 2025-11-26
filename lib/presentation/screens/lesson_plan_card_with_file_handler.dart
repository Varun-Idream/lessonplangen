import 'package:flutter/material.dart';
import 'package:lessonplan/services/permission_handler_service.dart';
import 'package:lessonplan/services/file_download_service.dart';
import 'package:lessonplan/presentation/screens/file_viewer_screen.dart';

/// Real-world example: Lesson Plan Card with View/Download options
///
/// This widget shows how to integrate the file handler into your lesson plan UI
///
/// Usage:
/// LessonPlanCardWithFileHandler(
///   lessonTitle: 'Introduction to Flutter',
///   description: 'Learn the basics...',
///   filePath: '/path/to/lesson.html',
/// )

class LessonPlanCardWithFileHandler extends StatefulWidget {
  final String lessonTitle;
  final String description;
  final String? filePath; // HTML file path
  final String? instructor;
  final DateTime? createdDate;
  final void Function()? onDelete;

  const LessonPlanCardWithFileHandler({
    Key? key,
    required this.lessonTitle,
    required this.description,
    this.filePath,
    this.instructor,
    this.createdDate,
    this.onDelete,
  }) : super(key: key);

  @override
  State<LessonPlanCardWithFileHandler> createState() =>
      _LessonPlanCardWithFileHandlerState();
}

class _LessonPlanCardWithFileHandlerState
    extends State<LessonPlanCardWithFileHandler> {
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.lessonTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.instructor != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'By ${widget.instructor}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          // File action buttons (if file is available)
          if (widget.filePath != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isDownloading ? null : _handleViewFile,
                          icon: const Icon(Icons.visibility),
                          label: const Text('View'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              _isDownloading ? null : _handleDownloadFile,
                          icon: _isDownloading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.download),
                          label: Text(
                            _isDownloading ? 'Downloading...' : 'Download',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Handle view file button press
  void _handleViewFile() async {
    if (widget.filePath == null) {
      _showErrorSnackBar('No file available');
      return;
    }

    // Check if file exists
    final exists = await FileDownloadService.fileExists(widget.filePath!);
    if (!exists) {
      _showErrorSnackBar('File not found');
      return;
    }

    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FileViewerScreen(
            filePath: widget.filePath!,
            fileName: widget.lessonTitle,
          ),
        ),
      );
    }
  }

  /// Handle download file button press
  void _handleDownloadFile() async {
    if (widget.filePath == null) {
      _showErrorSnackBar('No file available');
      return;
    }

    // Check if file exists
    final exists = await FileDownloadService.fileExists(widget.filePath!);
    if (!exists) {
      _showErrorSnackBar('Source file not found');
      return;
    }

    setState(() => _isDownloading = true);

    try {
      // Generate file name
      final fileName = _sanitizeFileName('${widget.lessonTitle}.html');

      // Request permissions and download
      final success = await FileDownloadService.downloadFile(
        sourceFilePath: widget.filePath!,
        fileName: fileName,
      );

      if (mounted) {
        setState(() => _isDownloading = false);

        if (success) {
          _showSuccessSnackBar(
            'File downloaded successfully to Downloads folder',
          );
        } else {
          _showErrorSnackBar(
            'Download failed. Please grant storage permissions in app settings.',
            showSettings: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDownloading = false);
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    }
  }

  /// Show error message
  void _showErrorSnackBar(
    String message, {
    bool showSettings = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: showSettings
            ? SnackBarAction(
                label: 'Settings',
                textColor: Colors.white,
                onPressed: () {
                  PermissionHandlerService.openSettings();
                },
              )
            : null,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show success message
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Sanitize file name by removing invalid characters
  String _sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(' ', '_');
  }
}

/// Example list of lesson plans with file handlers
class LessonPlansListWithFileHandler extends StatelessWidget {
  final List<LessonPlanData> lessonPlans;

  const LessonPlansListWithFileHandler({
    Key? key,
    required this.lessonPlans,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lessonPlans.length,
      itemBuilder: (context, index) {
        final lesson = lessonPlans[index];
        return LessonPlanCardWithFileHandler(
          lessonTitle: lesson.title,
          description: lesson.description,
          filePath: lesson.filePath,
          instructor: lesson.instructor,
          createdDate: lesson.createdDate,
        );
      },
    );
  }
}

/// Simple data model for lesson plans
class LessonPlanData {
  final String title;
  final String description;
  final String? filePath;
  final String? instructor;
  final DateTime? createdDate;

  LessonPlanData({
    required this.title,
    required this.description,
    this.filePath,
    this.instructor,
    this.createdDate,
  });
}
