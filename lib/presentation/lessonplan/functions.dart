import 'dart:developer';
import 'dart:io';
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lessonplan/bloc/lessonplan/lesson_plan_cubit.dart';
import 'package:lessonplan/presentation/core/custom_button.dart';
import 'package:lessonplan/presentation/core/error_dialog.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/lesson_plan_form.dart';
import 'package:lessonplan/services/injection/getit.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/router/router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class LessonPlanFunctions {
  static void showAuthError() {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      final ctx = sl<AppRouter>().navigatorKey.currentContext;
      if (ctx == null) {
        return;
      }

      showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (context) {
          return ErrorDialog(
            title:
                "Error Occured While Authentication \n Kindly retry after some time \n or hit the retry button below",
            actions: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  backgroundColor: ColorConstants.lightGrey,
                  textColor: ColorConstants.grey,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  onTap: () {
                    sl<AppRouter>().pop();
                    sl<AppRouter>().pop();
                  },
                  title: "Dismiss",
                ),
                const SizedBox(width: 10),
                CustomButton(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  onTap: () {
                    sl<LessonPlanCubit>().authenticateUser();
                  },
                  title: "Retry",
                ),
              ],
            ),
          );
        },
      ).then((r) {
        isErrorDialogMounted = false;
      });
    });
  }

  static void processPDF({
    required Map<String, dynamic> generatedData,
  }) async {
    try {
      final pdf = pw.Document(
        title: 'Lessson Plan',
        author: "Varun Dev",
      );

      final pageTheme = await loadPageTheme(
        format: PdfPageFormat.a4,
      );

      // 1st Page
      final logo = await rootBundle.loadString(
        "assets/images/svgs/logo.svg",
      );

      final baseFont = await rootBundle.load("fonts/Inter-Regular.ttf");
      final semiBoldFont = await rootBundle.load("fonts/Inter-SemiBold.ttf");
      final boldFont = await rootBundle.load("fonts/Inter-Bold.ttf");

      Intl.defaultLocale = 'en-US';

      pw.Widget blockBox({
        required String title,
        pw.Widget? child,
      }) =>
          pw.Container(
            width: double.maxFinite,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColor.fromHex('#dedede'),
                width: 1,
              ),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.ClipRRect(
              horizontalRadius: 8,
              verticalRadius: 8,
              child: pw.Column(
                children: [
                  pw.Container(
                    width: double.maxFinite,
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#F0F7FF'),
                    ),
                    padding: pw.EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: pw.Text(
                      "Learning Objectives",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#212121'),
                        fontSize: 12,
                        font: pw.Font.ttf(semiBoldFont),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (child != null) child,
                ],
              ),
            ),
          );

      final learningObjectives = generatedData['learning_standards']
              ?['smart_learning_objectives']?['objects']?['ai_recommendations']
          as List;

      pdf.addPage(
        pw.Page(
          pageTheme: pageTheme,
          build: (pw.Context context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(
                margin: pw.EdgeInsets.symmetric(horizontal: 40),
                child: pw.Column(
                  children: [
                    pw.SizedBox(height: 20),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [pw.SvgImage(svg: logo)],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Text(
                              "Lesson Plan: ${generatedData["topic"]}",
                              style: pw.TextStyle(
                                font: pw.Font.ttf(boldFont),
                                fontSize: 14,
                                color: PdfColor.fromHex('#0077FF'),
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisSize: pw.MainAxisSize.min,
                              children: [
                                pw.Text(
                                  "${generatedData["grade"]["name"]}",
                                  style: pw.TextStyle(
                                    color: PdfColor.fromHex('#666666'),
                                    fontSize: 12,
                                    font: pw.Font.ttf(baseFont),
                                  ),
                                ),
                                pw.SizedBox(width: 15),
                                pw.Text(
                                  "${generatedData["subject"]["name"]}",
                                  style: pw.TextStyle(
                                    color: PdfColor.fromHex('#666666'),
                                    fontSize: 12,
                                    font: pw.Font.ttf(baseFont),
                                  ),
                                ),
                                pw.SizedBox(width: 15),
                                pw.Container(
                                  padding: pw.EdgeInsets.all(6),
                                  decoration: pw.BoxDecoration(
                                    borderRadius: pw.BorderRadius.circular(4),
                                    color: PdfColor.fromHex('#8AC926'),
                                  ),
                                  child: pw.Text(
                                    "${generatedData["duration_minutes"]} Minutes",
                                    style: pw.TextStyle(
                                      color: PdfColor.fromHex('#212121'),
                                      fontSize: 12,
                                      font: pw.Font.ttf(semiBoldFont),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Text(
                              "Created By: Mr. Varun Dev",
                              style: pw.TextStyle(
                                color: PdfColor.fromHex('#666666'),
                                fontSize: 12,
                                font: pw.Font.ttf(baseFont),
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Text(
                              DateFormat.yMMMMd('en_US').format(DateTime.now()),
                              style: pw.TextStyle(
                                color: PdfColor.fromHex('#666666'),
                                fontSize: 12,
                                font: pw.Font.ttf(baseFont),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    pw.SizedBox(height: 25),
                    blockBox(
                      title: 'Learning Objectives',
                      child: pw.ListView.separated(
                        padding: pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        itemCount: learningObjectives.length,
                        itemBuilder: (context, index) {
                          return pw.Text(
                            "\u2022 ${learningObjectives[index]}",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex('#666666'),
                              font: pw.Font.ttf(baseFont),
                              fontSize: 12,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return pw.SizedBox(height: 8);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      final fileHandle = File("${Directory.current.path}\\${"LessonPlan.pdf"}");
      fileHandle.writeAsBytesSync(await pdf.save());
    } catch (e) {
      log('$e');
    }
  }

  static Future<pw.PageTheme> loadPageTheme({
    required PdfPageFormat format,
  }) async {
    try {
      final bgWaterMark = await rootBundle.loadString(
        "assets/images/svgs/watermark.svg",
      );

      // format = format.applyMargin(
      //   left: 2.0 * PdfPageFormat.cm,
      //   top: 2.0 * PdfPageFormat.cm,
      //   right: 2.0 * PdfPageFormat.cm,
      //   bottom: 2.0 * PdfPageFormat.cm,
      // );

      final baseFont = await rootBundle.load("fonts/Inter-Regular.ttf");
      final boldFont = await rootBundle.load("fonts/Inter-Bold.ttf");

      return pw.PageTheme(
        pageFormat: format,
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(baseFont),
          bold: pw.Font.ttf(boldFont),
          fontFallback: [
            pw.Font.helvetica(),
            pw.Font.helveticaBold(),
          ],
        ),
        buildBackground: (pw.Context context) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Stack(
              alignment: pw.Alignment.center,
              children: [
                pw.Positioned(
                  child: pw.SvgImage(svg: bgWaterMark),
                ),
                pw.Positioned(
                  right: 0,
                  top: 0,
                  child: pw.Container(
                    height: 30,
                    width: 100,
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(
                        ColorConstants.accentColors[Random().nextInt(3)]
                            .toARGB32(),
                      ),
                      borderRadius: pw.BorderRadius.only(
                        bottomLeft: pw.Radius.circular(16),
                      ),
                    ),
                  ),
                ),
                pw.Positioned(
                  left: 0,
                  bottom: 0,
                  child: pw.Container(
                    height: 30,
                    width: 100,
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(
                        ColorConstants.accentColors[Random().nextInt(3)]
                            .toARGB32(),
                      ),
                      borderRadius: pw.BorderRadius.only(
                        topRight: pw.Radius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
