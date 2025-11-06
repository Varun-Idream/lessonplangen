import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lessonplan/models/lesson_plan_history_model.dart';
import 'package:lessonplan/presentation/lessonplan/functions.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class HistoryPdfHandler {
  static Future<void> viewLessonPlan(
    BuildContext context,
    LessonPlanHistoryModel item,
  ) async {
    await _generateAndOpenPDF(context, item);
  }

  static Future<void> downloadLessonPlan(
    BuildContext context,
    LessonPlanHistoryModel item,
  ) async {
    await _generateAndSavePDF(context, item, shouldOpen: false);
  }

  static Future<void> _generateAndOpenPDF(
    BuildContext context,
    LessonPlanHistoryModel item,
  ) async {
    await _generateAndSavePDF(context, item, shouldOpen: true);
  }

  static Future<void> _generateAndSavePDF(
    BuildContext context,
    LessonPlanHistoryModel item, {
    required bool shouldOpen,
  }) async {
    try {
      if (!_isValidLessonPlanData(item.data)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Lesson plan data is incomplete. This lesson plan may not have been fully generated.',
              ),
              backgroundColor: ColorConstants.primaryRed,
            ),
          );
        }
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final pdfBytes = await LessonPlanFunctions.processPDF(
        generatedData: item.data,
      );

      final directory = await _getDownloadDirectory();
      final fileName = 'Lesson Plan-${item.lessonPlanID}.pdf';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (shouldOpen) {
        final result = await OpenFile.open(filePath);
        if (context.mounted) {
          if (result.type != ResultType.done) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error opening file: ${result.message}'),
                backgroundColor: ColorConstants.primaryRed,
              ),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PDF downloaded successfully!'),
                  const SizedBox(height: 4),
                  Text(
                    'Location: ${directory.path}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              backgroundColor: ColorConstants.naturalGreen,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error ${shouldOpen ? 'viewing' : 'downloading'} PDF: $e'),
            backgroundColor: ColorConstants.primaryRed,
          ),
        );
      }
    }
  }

  static Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final basePath = directory.path.split('Android')[0];
        final downloadPath = '$basePath${Platform.pathSeparator}Download';
        final downloadDir = Directory(downloadPath);
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        return downloadDir;
      }
    } else if (Platform.isWindows) {
      final documentsDir = await getApplicationDocumentsDirectory();
      final basePath = documentsDir.path.split('AppData')[0];
      final downloadPath = '$basePath${Platform.pathSeparator}Downloads';
      final downloadDir = Directory(downloadPath);
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      return downloadDir;
    } else if (Platform.isMacOS || Platform.isIOS) {
      final documentsDir = await getApplicationDocumentsDirectory();
      final downloadPath =
          '${documentsDir.path}${Platform.pathSeparator}Downloads';
      final downloadDir = Directory(downloadPath);
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      return downloadDir;
    }

    return await getApplicationDocumentsDirectory();
  }

  static bool _isValidLessonPlanData(Map<String, dynamic> data) {
    try {
      if (data['content_generation'] == null) {
        return false;
      }

      final contentGeneration =
          data['content_generation'] as Map<String, dynamic>?;
      if (contentGeneration == null) {
        return false;
      }

      if (contentGeneration['introduction_block'] == null) {
        return false;
      }

      final introductionBlock =
          contentGeneration['introduction_block'] as Map<String, dynamic>?;
      if (introductionBlock == null ||
          introductionBlock['components'] == null) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
