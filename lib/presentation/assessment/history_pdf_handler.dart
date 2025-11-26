import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lessonplan/models/assessment_history_model.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
      final savedPath = await AssessmentHtmlGenerator.downloadHtml(
          htmlString, item.topics ?? 'assessment');

      if (context.mounted) Navigator.of(context).pop();

      if (savedPath == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save assessment'),
              backgroundColor: ColorConstants.primaryRed,
            ),
          );
        }
        return;
      }

      if (shouldOpen) {
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder: (ctx) => Dialog(
            insetPadding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.85,
              child: InAppWebView(
                initialUrlRequest:
                    URLRequest(url: WebUri.uri(Uri.file(savedPath))),
                initialSettings: InAppWebViewSettings(
                  useShouldOverrideUrlLoading: true,
                ),
              ),
            ),
          ),
        );
      } else {
        if (context.mounted) {
          final dir = File(savedPath).parent.path;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('HTML downloaded successfully!'),
                  const SizedBox(height: 4),
                  Text('Location: $dir', style: const TextStyle(fontSize: 12)),
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

  // Download directory resolved via FileDownloadService; local helper removed.

  static bool _isValidAssessmentData(Map<String, dynamic> data) {
    try {
      // Consider valid if it has either question configuration or generated questions
      if (data['question_configuration'] == null && data['questions'] == null) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
