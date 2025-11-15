import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:file_saver/file_saver.dart';
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

  static String sanitize(String s) => s.replaceAllMapped(
        RegExp(r'\\u([0-9a-fA-F]{4})'),
        (Match m) => String.fromCharCode(int.parse(m.group(1)!, radix: 16)),
      );

  static Future<Uint8List> processPDF({
    required Map<String, dynamic> generatedData,
  }) async {
    try {
      final pdf = pw.Document(
        title: 'Lessson Plan: ${generatedData["topic"]}',
        author: "Varun Dev",
      );

      final notesIcon = await rootBundle.loadString(
        "assets/images/svgs/notes.svg",
      );

      final pageFormat = PdfPageFormat(
        PdfPageFormat.a4.width,
        1400,
      );

      final pageTheme = await loadPageTheme(
        format: pageFormat,
      );

      final baseFontBytes = await rootBundle.load("fonts/Inter-Regular.ttf");
      final mediumFontBytes = await rootBundle.load("fonts/Inter-Medium.ttf");
      final semiBoldFontBytes =
          await rootBundle.load("fonts/Inter-SemiBold.ttf");
      final boldFontBytes = await rootBundle.load("fonts/Inter-Bold.ttf");

      final baseFont = pw.Font.ttf(baseFontBytes);
      final mediumFont = pw.Font.ttf(mediumFontBytes);
      final semiBoldFont = pw.Font.ttf(semiBoldFontBytes);
      final boldFont = pw.Font.ttf(boldFontBytes);

      Intl.defaultLocale = 'en-US';

      pw.Widget blockBox({
        String? title,
        pw.Widget? customTitle,
        pw.Widget? headerSuffix,
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
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        if (customTitle != null)
                          pw.Expanded(child: customTitle)
                        else
                          pw.Expanded(
                            child: pw.Text(
                              title ?? "",
                              style: pw.TextStyle(
                                color: PdfColor.fromHex('#212121'),
                                fontSize: 12,
                                font: semiBoldFont,
                              ),
                              maxLines: 3,
                            ),
                          ),
                        pw.SizedBox(width: 20),
                        if (headerSuffix != null) headerSuffix,
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (child != null) child,
                ],
              ),
            ),
          );

      pw.Widget planBlocks({
        required String implementationScript,
        List formativeQuestions = const [],
        List expectedResponse = const [],
        String teacherNotes = '',
        bool ulImplS = true,
      }) {
        List<String> implS = sanitize(implementationScript).split("\n");
        implS.removeWhere((item) => item.isEmpty);

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Implementation Script:",
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 10,
              ),
            ),
            pw.SizedBox(height: 5),
            ...List.generate(
              implS.length,
              (index) {
                final impl = implS[index];
                return pw.Container(
                  margin: pw.EdgeInsets.only(bottom: 5),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (ulImplS)
                        pw.Text(
                          "\u2022 ",
                          style: pw.TextStyle(
                            color: PdfColor.fromHex('#666666'),
                            font: baseFont,
                            fontSize: 10,
                          ),
                        ),
                      if (ulImplS) pw.SizedBox(width: 5),
                      pw.Expanded(
                        child: pw.Text(
                          impl,
                          style: pw.TextStyle(
                            color: PdfColor.fromHex('#666666'),
                            font: baseFont,
                            fontSize: 10,
                          ),
                          maxLines: 100,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            pw.Text(
              "Formative Questions:",
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 10,
              ),
            ),
            pw.SizedBox(height: 8),
            ...List.generate(
              formativeQuestions.length,
              (index) {
                final question = formativeQuestions[index];
                return pw.Container(
                  margin: pw.EdgeInsets.only(
                    bottom: index != formativeQuestions.length - 1 ? 8 : 0,
                  ),
                  child: pw.Text(
                    "Q${index + 1}. $question",
                    style: pw.TextStyle(
                      font: baseFont,
                      fontSize: 10,
                      color: PdfColor.fromHex('#666666'),
                    ),
                  ),
                );
              },
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              "Expected Responses:",
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 10,
                color: PdfColor.fromHex("#1E8E55"),
              ),
            ),
            pw.SizedBox(height: 8),
            ...List.generate(
              expectedResponse.length,
              (index) {
                final response = expectedResponse[index];
                return pw.Container(
                  margin: pw.EdgeInsets.only(
                    bottom: index != expectedResponse.length - 1 ? 8 : 0,
                  ),
                  child: pw.Text(
                    "Ans ${index + 1}. $response",
                    style: pw.TextStyle(
                      font: baseFont,
                      fontSize: 10,
                      color: PdfColor.fromHex('#666666'),
                    ),
                  ),
                );
              },
            ),
            pw.SizedBox(height: 15),
            if (teacherNotes.isNotEmpty)
              pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(8),
                  color: PdfColor.fromHex("#f0f7ff"),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.all(5),
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        color: PdfColor.fromHex('#ffffff'),
                      ),
                      child: pw.SvgImage(svg: notesIcon),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Expanded(
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Teacher Notes:",
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 10,
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Text(
                            teacherNotes,
                            style: pw.TextStyle(
                              font: baseFont,
                              color: PdfColor.fromHex('#666666'),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      }

      final learningObjectives = generatedData['learning_standards']
              ?['smart_learning_objectives']?['objects']?['ai_recommendations']
          as List;

      final introductionComponents = generatedData["content_generation"]
          ["introduction_block"]["components"] as List;
      final developmentComponets = generatedData["content_generation"]
          ["development_block"]["components"] as List;
      final guidedPracticeComponets = generatedData["content_generation"]
          ["guided_practice_block"]["components"] as List;
      final ipPracticeComponents = generatedData["content_generation"]
          ["independent_practice_block"]["components"] as List;
      final closureComponets = generatedData["content_generation"]
          ["closure_block"]["components"] as List;
      final assessmentComponets = generatedData["content_generation"]
          ["assessment_block"]["components"] as List;

      pdf.addPage(
        pw.MultiPage(
          maxPages: 200,
          pageTheme: pageTheme,
          build: (pw.Context context) {
            return [
              pw.Container(
                margin: pw.EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 40,
                ),
                child: pw.Column(
                  children: [
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
                                font: boldFont,
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
                                    font: baseFont,
                                  ),
                                ),
                                pw.SizedBox(width: 15),
                                pw.Text(
                                  "${generatedData["subject"]["name"]}",
                                  style: pw.TextStyle(
                                    color: PdfColor.fromHex('#666666'),
                                    fontSize: 12,
                                    font: baseFont,
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
                                      font: semiBoldFont,
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
                                font: baseFont,
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Text(
                              DateFormat.yMMMMd('en_US').format(DateTime.now()),
                              style: pw.TextStyle(
                                color: PdfColor.fromHex('#666666'),
                                fontSize: 12,
                                font: baseFont,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    blockBox(
                      title: 'Learning Objectives',
                      child: pw.ListView.separated(
                        padding: pw.EdgeInsets.symmetric(
                          horizontal: 10,
                        ).copyWith(bottom: 20),
                        itemCount: learningObjectives.length,
                        itemBuilder: (context, index) {
                          return pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(
                                "\u2022 ",
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex('#666666'),
                                  font: baseFont,
                                  fontSize: 10,
                                ),
                              ),
                              pw.SizedBox(width: 5),
                              pw.Expanded(
                                child: pw.Text(
                                  learningObjectives[index],
                                  style: pw.TextStyle(
                                    color: PdfColor.fromHex('#666666'),
                                    font: baseFont,
                                    fontSize: 10,
                                  ),
                                  maxLines: 100,
                                  overflow: pw.TextOverflow.clip,
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return pw.SizedBox(height: 8);
                        },
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    ...List.generate(introductionComponents.length, (index) {
                      final component = introductionComponents[index];
                      final firstIndex = index == 0;
                      final cpName = firstIndex ? "Introduction: " : "";
                      final implementationScript =
                          component["implementation_script"];
                      final formativeQuestions =
                          component["formative_questions"];
                      final expectedResponses = component["expected_responses"];
                      final teacherNotes = component["teacher_notes"];

                      return pw.Container(
                        margin: pw.EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: blockBox(
                          customTitle: pw.RichText(
                            softWrap: true,
                            tightBounds: true,
                            text: pw.TextSpan(
                              style: pw.TextStyle(
                                fontSize: 12,
                              ),
                              children: [
                                pw.TextSpan(
                                  text: cpName,
                                  style: pw.TextStyle(
                                    font: boldFont,
                                  ),
                                ),
                                pw.WidgetSpan(
                                  child: pw.SizedBox(width: 4),
                                ),
                                pw.TextSpan(
                                  text: "${component["component_name"]}",
                                  style: pw.TextStyle(
                                    font: firstIndex ? mediumFont : boldFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          headerSuffix: pw.Text(
                            "${component["duration_minutes"]} Minutes",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex('#0077ff'),
                              font: boldFont,
                              fontSize: 12,
                            ),
                          ),
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                              horizontal: 20,
                            ).copyWith(bottom: 15),
                            child: planBlocks(
                              implementationScript: implementationScript,
                              formativeQuestions: formativeQuestions,
                              expectedResponse: expectedResponses,
                              teacherNotes: teacherNotes,
                            ),
                          ),
                        ),
                      );
                    }),
                    ...List.generate(developmentComponets.length, (index) {
                      final component = developmentComponets[index];
                      final firstIndex = index == 0;
                      final cpName = firstIndex ? "Development: " : "";
                      final implementationScript =
                          component["implementation_script"];
                      final formativeQuestions =
                          component["formative_questions"];
                      final expectedResponses = component["expected_responses"];
                      final teacherNotes = component["teacher_notes"];

                      return pw.Container(
                        margin: pw.EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: blockBox(
                          customTitle: pw.RichText(
                            text: pw.TextSpan(
                              style: pw.TextStyle(
                                fontSize: 12,
                              ),
                              children: [
                                pw.TextSpan(
                                  text: cpName,
                                  style: pw.TextStyle(
                                    font: boldFont,
                                  ),
                                ),
                                pw.WidgetSpan(
                                  child: pw.SizedBox(width: 4),
                                ),
                                pw.TextSpan(
                                  text: "${component["component_name"]}",
                                  style: pw.TextStyle(
                                    font: firstIndex ? mediumFont : boldFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          headerSuffix: pw.Text(
                            "${component["duration_minutes"]} Minutes",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex('#0077ff'),
                              font: boldFont,
                              fontSize: 12,
                            ),
                          ),
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                              horizontal: 20,
                            ).copyWith(bottom: 15),
                            child: planBlocks(
                              implementationScript: implementationScript,
                              formativeQuestions: formativeQuestions,
                              expectedResponse: expectedResponses,
                              teacherNotes: teacherNotes,
                            ),
                          ),
                        ),
                      );
                    }),
                    ...List.generate(guidedPracticeComponets.length, (index) {
                      final component = guidedPracticeComponets[index];
                      final firstIndex = index == 0;
                      final cpName = firstIndex ? "Guided Practice: " : "";
                      final implementationScript =
                          component["implementation_script"];
                      final formativeQuestions =
                          component["formative_questions"];
                      final expectedResponses = component["expected_responses"];
                      final teacherNotes = component["teacher_notes"];

                      return pw.Container(
                        margin: pw.EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: blockBox(
                          customTitle: pw.RichText(
                            text: pw.TextSpan(
                              style: pw.TextStyle(
                                fontSize: 12,
                              ),
                              children: [
                                pw.TextSpan(
                                  text: cpName,
                                  style: pw.TextStyle(
                                    font: boldFont,
                                  ),
                                ),
                                pw.WidgetSpan(
                                  child: pw.SizedBox(width: 4),
                                ),
                                pw.TextSpan(
                                  text: "${component["component_name"]}",
                                  style: pw.TextStyle(
                                    font: firstIndex ? mediumFont : boldFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          headerSuffix: pw.Text(
                            "${component["duration_minutes"]} Minutes",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex('#0077ff'),
                              font: boldFont,
                              fontSize: 12,
                            ),
                          ),
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                              horizontal: 20,
                            ).copyWith(bottom: 15),
                            child: planBlocks(
                              implementationScript: implementationScript,
                              formativeQuestions: formativeQuestions,
                              expectedResponse: expectedResponses,
                              teacherNotes: teacherNotes,
                            ),
                          ),
                        ),
                      );
                    }),
                    ...List.generate(ipPracticeComponents.length, (index) {
                      final component = ipPracticeComponents[index];
                      final firstIndex = index == 0;
                      final cpName = firstIndex ? "Independent Practice: " : "";
                      final implementationScript =
                          component["implementation_script"];
                      final formativeQuestions =
                          component["formative_questions"];
                      final expectedResponses = component["expected_responses"];
                      final teacherNotes = component["teacher_notes"];

                      return pw.Container(
                        margin: pw.EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: blockBox(
                          customTitle: pw.RichText(
                            text: pw.TextSpan(
                              style: pw.TextStyle(
                                fontSize: 12,
                              ),
                              children: [
                                pw.TextSpan(
                                  text: cpName,
                                  style: pw.TextStyle(
                                    font: boldFont,
                                  ),
                                ),
                                pw.WidgetSpan(
                                  child: pw.SizedBox(width: 4),
                                ),
                                pw.TextSpan(
                                  text: "${component["component_name"]}",
                                  style: pw.TextStyle(
                                    font: firstIndex ? mediumFont : boldFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          headerSuffix: pw.Text(
                            "${component["duration_minutes"]} Minutes",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex('#0077ff'),
                              font: boldFont,
                              fontSize: 12,
                            ),
                          ),
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                              horizontal: 20,
                            ).copyWith(bottom: 15),
                            child: planBlocks(
                              implementationScript: implementationScript,
                              formativeQuestions: formativeQuestions,
                              expectedResponse: expectedResponses,
                              teacherNotes: teacherNotes,
                            ),
                          ),
                        ),
                      );
                    }),
                    ...List.generate(closureComponets.length, (index) {
                      final component = closureComponets[index];
                      final firstIndex = index == 0;
                      final cpName = firstIndex ? "Closure: " : "";
                      final implementationScript =
                          component["implementation_script"];
                      final formativeQuestions =
                          component["formative_questions"];
                      final expectedResponses = component["expected_responses"];
                      final teacherNotes = component["teacher_notes"];

                      return pw.Container(
                        margin: pw.EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: blockBox(
                          customTitle: pw.RichText(
                            text: pw.TextSpan(
                              style: pw.TextStyle(
                                fontSize: 12,
                              ),
                              children: [
                                pw.TextSpan(
                                  text: cpName,
                                  style: pw.TextStyle(
                                    font: boldFont,
                                  ),
                                ),
                                pw.WidgetSpan(
                                  child: pw.SizedBox(width: 4),
                                ),
                                pw.TextSpan(
                                  text: "${component["component_name"]}",
                                  style: pw.TextStyle(
                                    font: firstIndex ? mediumFont : boldFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          headerSuffix: pw.Text(
                            "${component["duration_minutes"]} Minutes",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex('#0077ff'),
                              font: boldFont,
                              fontSize: 12,
                            ),
                          ),
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                              horizontal: 20,
                            ).copyWith(bottom: 15),
                            child: planBlocks(
                              implementationScript: implementationScript,
                              formativeQuestions: formativeQuestions,
                              expectedResponse: expectedResponses,
                              teacherNotes: teacherNotes,
                            ),
                          ),
                        ),
                      );
                    }),
                    ...List.generate(assessmentComponets.length, (index) {
                      final component = assessmentComponets[index];
                      final firstIndex = index == 0;
                      final cpName = firstIndex ? "Assessment: " : "";
                      final implementationScript =
                          component["implementation_script"];
                      final formativeQuestions =
                          component["formative_questions"];
                      final expectedResponses = component["expected_responses"];
                      final teacherNotes = component["teacher_notes"];

                      return pw.Container(
                        margin: pw.EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: blockBox(
                          customTitle: pw.RichText(
                            text: pw.TextSpan(
                              style: pw.TextStyle(
                                fontSize: 12,
                              ),
                              children: [
                                pw.TextSpan(
                                  text: cpName,
                                  style: pw.TextStyle(
                                    font: boldFont,
                                  ),
                                ),
                                pw.WidgetSpan(
                                  child: pw.SizedBox(width: 4),
                                ),
                                pw.TextSpan(
                                  text: "${component["component_name"]}",
                                  style: pw.TextStyle(
                                    font: firstIndex ? mediumFont : boldFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          headerSuffix: pw.Text(
                            "${component["duration_minutes"]} Minutes",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex('#0077ff'),
                              font: boldFont,
                              fontSize: 12,
                            ),
                          ),
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                              horizontal: 20,
                            ).copyWith(bottom: 15),
                            child: planBlocks(
                              implementationScript: implementationScript,
                              formativeQuestions: formativeQuestions,
                              expectedResponse: expectedResponses,
                              teacherNotes: teacherNotes,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ];
          },
        ),
      );

      return await pdf.save();
    } catch (e) {
      log('$e');
      rethrow;
    }
  }

  static Future<pw.PageTheme> loadPageTheme({
    required PdfPageFormat format,
  }) async {
    try {
      final bgWaterMark = await rootBundle.loadString(
        "assets/images/svgs/watermark.svg",
      );

      final logo = await rootBundle.loadString(
        "assets/images/svgs/logo.svg",
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
        ),
        buildBackground: (pw.Context context) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Stack(
              alignment: pw.Alignment.topCenter,
              children: [
                if (context.pageNumber == 1)
                  pw.Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [pw.SvgImage(svg: logo)],
                    ),
                  )
                else
                  pw.SizedBox(),
                pw.Positioned.fill(
                  top: 0,
                  child: pw.Center(
                    child: pw.SvgImage(svg: bgWaterMark),
                  ),
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

class HtmlGenerator {
  /// Generates the complete HTML content as a string from the lesson data.
  static Future<String> generateLessonHtml(
    Map<String, dynamic> generatedData,
  ) async {
    // Use a StringBuffer for efficient string building
    final buffer = StringBuffer();

    // Data extraction (with null safety)
    final String topic = generatedData["topic"] ?? "Untitled Lesson";
    final String grade = generatedData["grade"]?["name"] ?? "N/A";
    final String subject = generatedData["subject"]?["name"] ?? "N/A";
    final int duration = generatedData["duration_minutes"] ?? 0;
    final String formattedDate =
        "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"; // Simple date format

    final List learningObjectives = generatedData['learning_standards']
                ?['smart_learning_objectives']?['objects']
            ?['ai_recommendations'] as List? ??
        [];

    final List introComponents = generatedData["content_generation"]
            ?["introduction_block"]?["components"] as List? ??
        [];
    final List devComponents = generatedData["content_generation"]
            ?["development_block"]?["components"] as List? ??
        [];
    final List guidedComponents = generatedData["content_generation"]
            ?["guided_practice_block"]?["components"] as List? ??
        [];
    final List ipComponents = generatedData["content_generation"]
            ?["independent_practice_block"]?["components"] as List? ??
        [];
    final List closureComponents = generatedData["content_generation"]
            ?["closure_block"]?["components"] as List? ??
        [];
    final List assessmentComponents = generatedData["content_generation"]
            ?["assessment_block"]?["components"] as List? ??
        [];

    // --- Start HTML Document ---
    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="en">');
    buffer.writeln('<head>');
    buffer.writeln('    <meta charset="UTF-8">');
    buffer.writeln(
        '    <meta name="viewport" content="width=device-width, initial-scale=1.0">');
    buffer.writeln('    <title>Lesson Plan: $topic</title>');
    buffer.writeln('    <script src="https://cdn.tailwindcss.com"></script>');
    buffer.writeln(
        '    <link rel="preconnect" href="https://fonts.googleapis.com">');
    buffer.writeln(
        '    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>');
    buffer.writeln(
        '    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">');
    buffer.writeln('    <style>');
    buffer.writeln('        body { font-family: \'Inter\', sans-serif; }');
    buffer.writeln('        .bg-lesson-header { background-color: #F0F7FF; }');
    buffer.writeln('        .border-lesson-box { border-color: #dedede; }');
    buffer.writeln('        .text-lesson-title { color: #0077FF; }');
    buffer.writeln('        .text-lesson-body { color: #666666; }');
    buffer.writeln('        .text-lesson-dark { color: #212121; }');
    buffer
        .writeln('        .bg-lesson-duration { background-color: #8AC926; }');
    buffer.writeln('        .text-lesson-response { color: #1E8E55; }');
    buffer.writeln('        @media print {');
    buffer.writeln('            .no-print { display: none; }');
    buffer.writeln('            body { background-color: #ffffff; }');
    buffer.writeln(
        '            .page-container { margin: 0; box-shadow: none; border: none; }');
    buffer.writeln('        }');
    buffer.writeln('    </style>');
    buffer.writeln('</head>');
    buffer.writeln('<body class="bg-gray-100 text-lesson-dark">');
    buffer.writeln('    <!-- Decorative Elements (from loadPageTheme) -->');
    buffer.writeln(
        '    <div class="fixed top-0 right-0 h-8 w-24 bg-blue-300 rounded-bl-2xl no-print"></div>');
    buffer.writeln(
        '    <div class="fixed bottom-0 left-0 h-8 w-24 bg-green-300 rounded-tr-2xl no-print"></div>');
    buffer.writeln('    <!-- Watermark (from loadPageTheme) -->');
    buffer.writeln(
        '    <div class="fixed inset-0 flex items-center justify-center z-0 opacity-10 pointer-events-none no-print">');
    buffer.writeln(
        '        <span class="text-[10vw] font-bold text-gray-300 -rotate-45 select-none">');
    buffer.writeln('            Watermark');
    buffer.writeln('        </span>');
    buffer.writeln('    </div>');
    buffer.writeln('    <!-- Main Page Container -->');
    buffer.writeln(
        '    <div class="relative z-10 max-w-5xl mx-auto my-12 bg-white shadow-2xl rounded-lg border border-gray-200 p-10 md:p-16 page-container">');
    buffer.writeln('        <!-- Logo (from loadPageTheme) -->');
    buffer.writeln(
        '        <div class="text-center text-3xl font-bold text-gray-400 mb-10">');
    buffer.writeln(
        '            <svg width="108" height="34" viewBox="0 0 108 34" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M13.129 15.344h6.014a6.74 6.74 0 0 0 6.74-6.737V.13h-9.258a3.5 3.5 0 0 0-3.496 3.496z" fill="#3EA3DC"/><path d="M10.254.13H3.498A3.5 3.5 0 0 0 0 3.628v19.864a3.493 3.493 0 0 0 3.496 3.495h5.012a1.75 1.75 0 0 0 1.749-1.747z" fill="#FC0"/><path d="M20.284 18.507h-7.155v6.736a1.75 1.75 0 0 0 1.749 1.747h7.632a3.366 3.366 0 0 0 3.365-3.363V15.51a6.72 6.72 0 0 1-5.591 2.997" fill="#86BC25"/><path d="M35.036.686a2.27 2.27 0 0 1 .683 1.672 2.22 2.22 0 0 1-.678 1.658 2.42 2.42 0 0 1-1.77.658 2.37 2.37 0 0 1-1.728-.663 2.22 2.22 0 0 1-.679-1.658 2.27 2.27 0 0 1 .68-1.672A2.34 2.34 0 0 1 33.271 0a2.4 2.4 0 0 1 1.764.685m.666 5.689h-4.818V26.84H35.7zm18.683-4.1q2.765 2.073 2.765 6.207 0 4.318-2.784 6.49-2.784 2.17-7.421 2.162H43.9v9.632h-4.966V.205h7.676q5 0 7.774 2.07M50.6 12.293q1.355-1.102 1.355-3.817 0-4.628-5.382-4.628H43.9v9.556h2.673q2.67.005 4.027-1.104zM71.091 6.11l-.828 4.664a7.3 7.3 0 0 0-1.768-.226c-1.18 0-2.027.563-2.786 1.261-.795.73-1.583 1.931-1.619 3.856v11.172h-4.817V6.375h4.178l.452 3.912q.714-2.145 2.074-3.292a4.7 4.7 0 0 1 3.125-1.147 7.2 7.2 0 0 1 1.99.263m17.481 9.745q0-4.741-2.297-7.393t-6.474-2.651q-2.748 0-4.742 1.381a8.7 8.7 0 0 0-3.049 3.8q-1.056 2.43-1.054 5.475 0 4.816 2.466 7.6 2.466 2.785 7.019 2.782 4.065 0 7.377-2.67l-.534-3.957q-.686.651-1.451 1.209c-.772.544-1.606.992-2.486 1.335a7.1 7.1 0 0 1-2.483.434q-2.107 0-3.387-1.242-1.281-1.242-1.506-4.146h12.495c.068-1.045.106-1.706.106-1.957m-4.78-1.16h-7.83q.187-2.862 1.186-4.158 1-1.298 2.765-1.298 3.877 0 3.877 5.229zm22.399-6.14Q108 11.303 108 16.267q0 3.087-.923 5.474-.922 2.388-2.71 3.743-1.789 1.354-4.234 1.354-3.162 0-5.012-2.181v8.035l-4.816.778V6.375h4.22l.263 2.446a7.8 7.8 0 0 1 2.673-2.256 6.96 6.96 0 0 1 3.161-.753q3.764-.003 5.57 2.744m-3.237 7.75q0-3.65-.94-5.267-.94-1.62-2.824-1.617c-.81.002-1.6.258-2.257.732a6.4 6.4 0 0 0-1.808 1.976v8.955q1.394 2.072 3.652 2.072 4.177 0 4.177-6.852" fill="#575756"/></svg>');
    buffer.writeln('        </div>');
    buffer.writeln('        <!-- Page Header (from processPDF build) -->');
    buffer.writeln(
        '        <header class="flex flex-col md:flex-row justify-between items-start md:items-center border-b border-gray-200 pb-6 mb-8">');
    buffer.writeln('            <!-- Left Side -->');
    buffer.writeln('            <div>');
    buffer.writeln(
        '                <h1 class="text-2xl font-bold text-lesson-title">');
    buffer.writeln('                    Lesson Plan: $topic');
    buffer.writeln('                </h1>');
    buffer.writeln(
        '                <div class="flex flex-wrap items-center gap-x-4 text-lesson-body text-sm mt-3">');
    buffer.writeln('                    <span>$grade</span>');
    buffer.writeln('                    <span class="text-gray-300">|</span>');
    buffer.writeln('                    <span>$subject</span>');
    buffer.writeln('                    <span class="text-gray-300">|</span>');
    buffer.writeln(
        '                    <span class="bg-lesson-duration text-gray-900 font-semibold px-3 py-1 rounded text-xs">');
    buffer.writeln('                        $duration Minutes');
    buffer.writeln('                    </span>');
    buffer.writeln('                </div>');
    buffer.writeln('            </div>');
    buffer.writeln('            <!-- Right Side -->');
    buffer.writeln(
        '            <div class="text-left md:text-right text-lesson-body text-sm mt-4 md:mt-0 flex-shrink-0">');
    buffer.writeln('                <p>Created By: Mr. Varun Dev</p>');
    buffer.writeln('                <p class="mt-1">$formattedDate</p>');
    buffer.writeln('            </div>');
    buffer.writeln('        </header>');
    buffer.writeln('        <!-- Main Content -->');
    buffer.writeln('        <main class="space-y-6">');

    // --- Learning Objectives ---
    buffer.writeln(_buildBlockBoxHtml('Learning Objectives', null, (b) {
      b.writeln(
          '<ul class="list-disc list-inside space-y-2 text-lesson-body text-sm">');
      if (learningObjectives.isEmpty) {
        b.writeln('<li>No learning objectives specified.</li>');
      } else {
        for (final objective in learningObjectives) {
          b.writeln(
              '<li>${_sanitize(_decodeUnicode(objective.toString()))}</li>');
        }
      }
      b.writeln('</ul>');
    }));

    // --- Dynamic Components ---
    _buildComponentSection(buffer, "Introduction", introComponents);
    _buildComponentSection(buffer, "Development", devComponents);
    _buildComponentSection(buffer, "Guided Practice", guidedComponents);
    _buildComponentSection(buffer, "Independent Practice", ipComponents);
    _buildComponentSection(buffer, "Closure", closureComponents);
    _buildComponentSection(buffer, "Assessment", assessmentComponents);

    // --- End HTML Document ---
    buffer.writeln('        </main>');
    buffer.writeln('    </div>');
    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
  }

  /// Triggers a download/save dialog for the generated HTML content.
  /// Requires the `file_saver` package.
  static Future<void> downloadHtml(String htmlContent, String topic) async {
    try {
      // Sanitize topic for use in a filename
      final String safeTopic = topic.replaceAll(RegExp(r'[^\w\s-]'), '_');
      final String fileName = 'Lesson-Plan-$safeTopic.html';

      // Convert the string content to Uint8List
      Uint8List bytes = utf8.encode(htmlContent);

      // Use FileSaver to save the file
      // This works on Web, Android, iOS, Windows, macOS, and Linux
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        mimeType: MimeType.custom,
        customMimeType: "text/html",
      );
    } catch (e) {
      debugPrint('Error saving HTML file: $e');
      // Handle or rethrow the error as needed
      rethrow;
    }
  }

  // --- HTML Builder Helper Functions ---

  /// Helper to build a "component" section (Intro, Development, etc.)
  static void _buildComponentSection(
      StringBuffer buffer, String sectionTitle, List components) {
    if (components.isEmpty) return;

    for (int i = 0; i < components.length; i++) {
      final component = components[i] as Map<String, dynamic>? ?? {};
      final bool firstIndex = i == 0;

      // Build the rich title
      final titleBuffer = StringBuffer();
      if (firstIndex) {
        titleBuffer.write(
            '<span class="font-bold">${_sanitize(sectionTitle)}:</span> ');
      }
      titleBuffer.write(
          _sanitize(component["component_name"] ?? "Untitled Component"));
      final String customTitle = titleBuffer.toString();
      final String duration = "${component["duration_minutes"] ?? 0} Minutes";

      buffer.writeln(_buildBlockBoxHtml(
        null, // Use customTitle instead
        customTitle,
        (b) {
          // This builds the inner content (Implementation, Questions, etc.)
          _buildPlanBlocksHtml(b, component);
        },
        headerSuffix:
            '<span class="text-sm font-bold text-lesson-title flex-shrink-0">$duration</span>',
      ));
    }
  }

  /// Replicates your `blockBox` PDF widget
  static String _buildBlockBoxHtml(
    String? title,
    String? customTitleHtml,
    void Function(StringBuffer) childBuilder, {
    String? headerSuffix,
  }) {
    final buffer = StringBuffer();
    buffer.writeln(
        '<section class="border border-lesson-box rounded-lg overflow-hidden">');
    // Header
    buffer.writeln(
        '<header class="bg-lesson-header px-5 py-3 border-b border-lesson-box flex justify-between items-center gap-4">');
    buffer.write(
        '<h2 class="text-base font-semibold text-lesson-dark flex-grow">');
    if (customTitleHtml != null) {
      buffer.write(customTitleHtml);
    } else {
      buffer.write(_sanitize(title ?? ""));
    }
    buffer.writeln('</h2>');
    if (headerSuffix != null) {
      buffer.writeln(headerSuffix);
    }
    buffer.writeln('</header>');
    // Content
    buffer.writeln('<div class="p-5">');
    childBuilder(buffer); // Build the inner content
    buffer.writeln('</div>');
    buffer.writeln('</section>');
    return buffer.toString();
  }

  /// Replicates your `planBlocks` PDF widget
  static void _buildPlanBlocksHtml(
      StringBuffer buffer, Map<String, dynamic> component) {
    final String implementationScript =
        component["implementation_script"] ?? "";
    final List formativeQuestions =
        component["formative_questions"] as List? ?? [];
    final List expectedResponses =
        component["expected_responses"] as List? ?? [];
    final String teacherNotes = component["teacher_notes"] ?? "";

    buffer.writeln('<div class="space-y-4">');

    // Implementation Script
    if (implementationScript.isNotEmpty) {
      buffer.writeln('<div>');
      buffer.writeln(
          '<h3 class="text-sm font-bold text-lesson-dark mb-2">Implementation Script:</h3>');
      buffer.writeln(
          '<ul class="list-disc list-inside space-y-1 text-lesson-body text-sm">');
      // Split script by newlines and filter empty lines
      final lines = implementationScript
          .split('\n')
          .where((line) => line.trim().isNotEmpty);
      for (final line in lines) {
        buffer.writeln('<li>${_sanitize(_decodeUnicode(line))}</li>');
      }
      buffer.writeln('</ul>');
      buffer.writeln('</div>');
    }

    // Formative Questions
    if (formativeQuestions.isNotEmpty) {
      buffer.writeln('<div>');
      buffer.writeln(
          '<h3 class="text-sm font-bold text-lesson-dark mb-2">Formative Questions:</h3>');
      buffer.writeln('<div class="space-y-2 text-lesson-body text-sm">');
      for (int i = 0; i < formativeQuestions.length; i++) {
        buffer.writeln(
            '<p><strong class="text-gray-700">Q${i + 1}.</strong> ${_sanitize(_decodeUnicode(formativeQuestions[i].toString()))}</p>');
      }
      buffer.writeln('</div>');
      buffer.writeln('</div>');
    }

    // Expected Responses
    if (expectedResponses.isNotEmpty) {
      buffer.writeln('<div>');
      buffer.writeln(
          '<h3 class="text-sm font-bold text-lesson-response mb-2">Expected Responses:</h3>');
      buffer.writeln('<div class="space-y-2 text-lesson-body text-sm">');
      for (int i = 0; i < expectedResponses.length; i++) {
        buffer.writeln(
            '<p><strong class="text-gray-700">Ans ${i + 1}.</strong> ${_sanitize(_decodeUnicode(expectedResponses[i].toString()))}</p>');
      }
      buffer.writeln('</div>');
      buffer.writeln('</div>');
    }

    // Teacher Notes
    if (teacherNotes.isNotEmpty) {
      buffer.writeln(
          '<div class="bg-lesson-header rounded-lg p-4 flex items-start space-x-3 mt-4">');
      buffer.writeln(
          '<div class="w-10 h-10 rounded-full bg-white flex items-center justify-center flex-shrink-0 shadow-sm">');
      buffer.writeln('<!-- Inline SVG for notesIcon -->');
      buffer.writeln(
          '<svg width="16" height="18" viewBox="0 0 16 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M15.497 6.114v9.553l-3.29 1.642-3.104-1.482-.935-.446 3.46-9.399z" fill="#F2F8FF"/><path d="M13.06 8.896c-.275 2.855-.85 8.413-.85 8.413l-3.105-1.482z" fill="#E5F0FC"/><path d="M5.821 4.306C4.634 9.529 0 13.422 0 13.422L8.854 18c4.547-4.544 4.822-10.582 4.822-10.582z" fill="#F2F8FF"/><path d="M15.861 4.149v2.135l-2.187 1.134L5.18 4.426V2.11l2.635-.917 6.769 2.487z" fill="#1D7EED"/><path d="M15.864 4.15v2.134l-2.187 1.134-.056-2.05s.45-.8.966-1.688z" fill="#07F"/><path d="m15.861 4.149-2.243 1.218L5.18 2.11l2.635-.917 6.769 2.487z" fill="#2B8EFF"/><path d="m15.2 3.906-.561-.207c.066-.476-.065-.864-.387-1.004-.521-.226-1.346.278-1.843 1.125s-.477 1.718.044 1.944c0 0 .248.515-.49.584-.875-.38-1.014-1.659-.312-2.857s1.98-1.862 2.854-1.483c.64.278.887 1.04.696 1.898M10.75 2.27l-.546-.2c.163-.597.051-1.11-.331-1.276-.521-.226-1.346.278-1.842 1.125-.497.848-.478 1.718.043 1.944 0 0 .287.656-.491.583-.874-.379-1.014-1.658-.311-2.856.703-1.2 1.98-1.863 2.854-1.483.706.307.933 1.2.624 2.163" fill="#212121"/><path d="m10.018 14.316-1.301.446-6.024 2.063-1.148-.209-1.24-.225a.355.355 0 0 1-.217-.583l1.554-1.783 7.326-2.51z" fill="#FDC500"/><path d="m8.717 14.763-6.024 2.063-1.148-.209a4 4 0 0 1-.092-.372l6.717-1.88.097-.028s.185.17.45.426" fill="#F6D14F"/><path d="m2.693 16.825-1.886-.342-.501-.092c-.282-.05-.402-.372-.218-.582l.326-.375 1.228-1.409c-.013.04-.532 1.568 1.051 2.8" fill="#FFEBD3"/><path d="m.807 16.482-.501-.091c-.282-.051-.402-.372-.218-.583l.326-.374s-.189.598.393 1.048" fill="#51518E"/><path d="M9.56 14.944c.688-.279.921-1.307.52-2.296-.401-.99-1.285-1.565-1.974-1.286-.688.28-.921 1.308-.52 2.297s1.285 1.565 1.973 1.285" fill="#E5F0FC"/><path d="m11.161 13.855-.04.013-1.29.442c-.427.146-1-.334-1.277-1.072-.277-.74-.154-1.457.275-1.604l1.329-.455.07-.018c.418-.077.945.39 1.207 1.09.277.739.155 1.457-.274 1.604" fill="#BAF064"/><path d="m11.16 13.855-.04.013c-.419.08-.947-.388-1.21-1.09-.277-.738-.154-1.456.274-1.603l.043-.014c.419-.077.946.39 1.208 1.09.277.739.154 1.457-.274 1.604" fill="#8AC926"/></svg>');
      buffer.writeln('</div>');
      buffer.writeln('<div>');
      buffer.writeln(
          '<h4 class="text-sm font-bold text-lesson-dark">Teacher Notes:</h4>');
      buffer.writeln('<p class="text-lesson-body text-sm mt-1">');
      buffer.writeln(_sanitize(_decodeUnicode(teacherNotes)));
      buffer.writeln('</p>');
      buffer.writeln('</div>');
      buffer.writeln('</div>');
    }

    buffer.writeln('</div>');
  }

  /// Decodes Unicode escape sequences in a string.
  /// For example, \u221a5 becomes √5
  static String _decodeUnicode(String s) => s.replaceAllMapped(
        RegExp(r'\\u([0-9a-fA-F]{4})'),
        (Match m) => String.fromCharCode(int.parse(m.group(1)!, radix: 16)),
      );

  /// Simple HTML sanitizer to prevent basic injection issues from data
  static String _sanitize(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }
}
