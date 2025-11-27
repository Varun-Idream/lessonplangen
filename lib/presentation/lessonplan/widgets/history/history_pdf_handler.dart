import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lessonplan/models/lesson_plan_history_model.dart';
import 'package:lessonplan/presentation/lessonplan/functions.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
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
        await showDialog(
          context: context,
          builder: (ctx) => Dialog(
            insetPadding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.85,
              child: InAppWebView(
                // On Android load the saved file path; on Windows load the HTML string directly
                initialUrlRequest: Platform.isAndroid
                    ? URLRequest(
                        url: WebUri.uri(
                          Uri.file(savedPath),
                        ),
                      )
                    : null,
                initialData: Platform.isWindows
                    ? InAppWebViewInitialData(
                        data: htmlString,
                        mimeType: 'text/html',
                        encoding: 'utf-8',
                      )
                    : null,
                onWebViewCreated: (controller) async {
                  if (Platform.isWindows) {
                    await controller.loadData(
                      data: htmlString,
                      mimeType: 'text/html',
                      encoding: 'utf-8',
                    );
                  }
                },
                initialSettings: InAppWebViewSettings(
                  useShouldOverrideUrlLoading: true,
                ),
              ),
            ),
          ),
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Saved to $savedPath'),
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
