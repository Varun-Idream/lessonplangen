import 'dart:developer';
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
        1000,
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
            pw.SizedBox(height: 8),
            ...List.generate(
              implS.length,
              (index) {
                final impl = implS[index];
                return pw.Container(
                  margin: pw.EdgeInsets.only(bottom: 8),
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
