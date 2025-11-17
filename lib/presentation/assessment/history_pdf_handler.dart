import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lessonplan/models/assessment_history_model.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'functions.dart';

class AssessmentHistoryPdfHandler {
  static Future<void> viewAssessmentHistory(
      BuildContext context, AssessmentHistoryModel item) async {
    await _generateAndOpenHTML(context, item);
  }

  static Future<void> downloadAssessmentHistory(
      BuildContext context, AssessmentHistoryModel item) async {
    await _generateAndSaveHTML(context, item, shouldOpen: false);
  }

  static Future<void> _generateAndOpenHTML(
      BuildContext context, AssessmentHistoryModel item) async {
    await _generateAndSaveHTML(context, item, shouldOpen: true);
  }

  static Future<void> _generateAndSaveHTML(
      BuildContext context, AssessmentHistoryModel item,
      {required bool shouldOpen}) async {
    try {
      if (!_isValidAssessmentData(item.data)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Assessment data is incomplete. This assessment may not have been fully generated.'),
              backgroundColor: ColorConstants.primaryRed,
            ),
          );
        }
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final htmlString =
          await AssessmentHtmlGenerator.generateAssessmentHtml(item.data);
      await AssessmentHtmlGenerator.downloadHtml(
          htmlString, item.topics ?? 'assessment');

      final String safeTopic =
          (item.topics ?? 'assessment').replaceAll(RegExp(r'[^\w\s-]'), '_');
      final String fileName = 'Assessment-$safeTopic.html';
      final directory = await _getDownloadDirectory();
      final filePath = '${directory.path}${Platform.pathSeparator}$fileName';

      if (context.mounted) Navigator.of(context).pop();

      if (shouldOpen) {
        final result = await OpenFile.open(filePath);
        if (context.mounted) {
          if (result.type != ResultType.done) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error opening file: ${result.message}'),
                  backgroundColor: ColorConstants.primaryRed),
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
                  const Text('HTML downloaded successfully!'),
                  const SizedBox(height: 4),
                  Text('Location: ${directory.path}',
                      style: const TextStyle(fontSize: 12)),
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
            content: Text(
                'Error ${shouldOpen ? 'viewing' : 'downloading'} HTML: $e'),
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
      final basePath = documentsDir.path.split('OneDrive')[0];
      final downloadPath = '${basePath}Downloads';
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
      if (!await downloadDir.exists())
        await downloadDir.create(recursive: true);
      return downloadDir;
    }

    return await getApplicationDocumentsDirectory();
  }

  static bool _isValidAssessmentData(Map<String, dynamic> data) {
    try {
      // Consider valid if it has either question configuration or generated questions
      if (data['question_configuration'] == null && data['questions'] == null)
        return false;
      return true;
    } catch (e) {
      return false;
    }
  }
}
