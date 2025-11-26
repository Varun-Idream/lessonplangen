import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lessonplan/models/lesson_plan_history_model.dart';
import 'package:lessonplan/presentation/lessonplan/functions.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
    await _generateAndSaveHTML(context, item, shouldOpen: false);
  }

  static Future<void> _generateAndOpenPDF(
    BuildContext context,
    LessonPlanHistoryModel item,
  ) async {
    await _generateAndSaveHTML(context, item, shouldOpen: true);
  }

  static Future<void> _generateAndSaveHTML(
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

      // final pdfBytes = await Lesson.processPDF(
      //   generatedData: item.data,
      // );

      final htmlString = await HtmlGenerator.generateLessonHtml(item.data);
      final savedPath =
          await HtmlGenerator.downloadHtml(htmlString, item.topics ?? "");

      if (context.mounted) Navigator.of(context).pop();

      if (savedPath == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save lesson plan'),
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
                  const Text('Lesson plan downloaded successfully!'),
                  const SizedBox(height: 4),
                  Text(
                    'Location: $dir',
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

  // Download directory resolved via FileDownloadService; local helper removed.

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
