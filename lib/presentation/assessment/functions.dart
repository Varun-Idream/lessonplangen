import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lessonplan/services/file_download_service.dart';

class AssessmentHtmlGenerator {
  /// Generates the complete HTML content for an assessment as a string.
  static Future<String> generateAssessmentHtml(
    Map<String, dynamic> generatedData,
  ) async {
    final buffer = StringBuffer();

    // Data extraction (with null safety)
    final String topic = generatedData["topic"] ?? "Untitled Assessment";
    final String grade = generatedData["grade"]?["name"] ?? "N/A";
    final String subject = generatedData["subject"]?["name"] ?? "N/A";
    final int numberOfQuestions = generatedData["number_of_questions"] ?? 0;
    final String formattedDate =
        DateFormat.yMMMMd('en_US').format(DateTime.now());

    final Map<String, dynamic> questionsData =
        generatedData["questions"] as Map<String, dynamic>? ?? {};

    // Extract question arrays from different types
    final List mcqSingleAnswer =
        questionsData["mcq_single_answer"] as List? ?? [];
    final List mcqMultipleAnswer =
        questionsData["mcq_multiple_answer"] as List? ?? [];
    final List trueFalse = questionsData["true_false"] as List? ?? [];
    final List fillInBlanks = questionsData["fill_in_blanks"] as List? ?? [];
    final List matchColumns = questionsData["match_the_columns"] as List? ?? [];
    final List veryShortAnswer =
        questionsData["very_short_answer"] as List? ?? [];
    final List shortAnswer = questionsData["short_answer"] as List? ?? [];
    final List longAnswer = questionsData["long_answer"] as List? ?? [];

    // --- Start HTML Document ---
    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="en">');
    buffer.writeln('<head>');
    buffer.writeln('    <meta charset="UTF-8">');
    buffer.writeln(
        '    <meta name="viewport" content="width=device-width, initial-scale=1.0">');
    buffer.writeln('    <title>Assessment: $topic</title>');
    buffer.writeln('    <script src="https://cdn.tailwindcss.com"></script>');
    buffer.writeln(
        '    <link rel="preconnect" href="https://fonts.googleapis.com">');
    buffer.writeln(
        '    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>');
    buffer.writeln(
        '    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">');
    buffer.writeln(
        '    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/katex.min.css">');
    buffer.writeln(
        '    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/katex.min.js"></script>');
    buffer.writeln(
        '    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/contrib/auto-render.min.js"></script>');
    buffer.writeln('    <script>');
    buffer.writeln(
        '      document.addEventListener("DOMContentLoaded", function() {');
    buffer.writeln('        if (window.renderMathInElement) {');
    buffer.writeln('          renderMathInElement(document.body, {');
    buffer.writeln('            delimiters: [');
    buffer.writeln(r"              {left: '$$', right: '$$', display: true},");
    buffer.writeln(r"              {left: '$', right: '$', display: false},");
    buffer
        .writeln(r"              {left: '\\(', right: '\\)', display: false},");
    buffer.writeln(r"              {left: '\\[', right: '\\]', display: true}");
    buffer.writeln('            ],');
    buffer.writeln('            throwOnError: false');
    buffer.writeln('          });');
    buffer.writeln('        }');
    buffer.writeln('      });');
    buffer.writeln('    </script>');

    buffer.writeln('    <style>');
    buffer.writeln('        body { font-family: \'Inter\', sans-serif; }');
    buffer.writeln(
        '        .bg-assessment-header { background-color: #F0F7FF; }');
    buffer.writeln('        .border-assessment-box { border-color: #dedede; }');
    buffer.writeln('        .text-assessment-title { color: #0077FF; }');
    buffer.writeln('        .text-assessment-body { color: #666666; }');
    buffer.writeln('        .text-assessment-dark { color: #212121; }');
    buffer.writeln(
        '        .bg-assessment-duration { background-color: #8AC926; }');
    buffer.writeln('        .text-assessment-meta { color: #666666; }');
    buffer.writeln('        .q-option { list-style-type: upper-alpha; }');
    buffer.writeln(
        '        .bloom-tag { background-color: #FFFFFF; color: #666666; border: 1px solid #666666; }');
    buffer.writeln(
        '        .difficulty-tag { background-color: #FFFFFF; color: #666666; border: 1px solid #666666; }');
    buffer.writeln(
        '        .learning-obj-tag { background-color: #E3F2FD; color: #1565C0; }');
    buffer.writeln('        @media print {');
    buffer.writeln('            .no-print { display: none; }');
    buffer.writeln('            body { background-color: #ffffff; }');
    buffer.writeln(
        '            .page-container { margin: 0; box-shadow: none; border: none; }');
    buffer.writeln('            .page-break { page-break-after: always; }');
    buffer.writeln('        }');
    buffer.writeln('    </style>');
    buffer.writeln('</head>');
    buffer.writeln('<body class="bg-gray-100 text-assessment-dark">');

    // Decorative Elements
    buffer.writeln(
        '    <div class="fixed top-0 right-0 h-8 w-24 bg-blue-300 rounded-bl-2xl no-print"></div>');
    buffer.writeln(
        '    <div class="fixed bottom-0 left-0 h-8 w-24 bg-yellow-300 rounded-tr-2xl no-print"></div>');

    // Watermark
    buffer.writeln(
        '    <div class="fixed inset-0 flex items-center justify-center z-0 opacity-10 pointer-events-none no-print">');
    buffer.writeln(
        '        <span class="text-[10vw] font-bold text-gray-300 -rotate-45 select-none">');
    buffer.writeln('            Assessment');
    buffer.writeln('        </span>');
    buffer.writeln('    </div>');

    // Main Page Container
    buffer.writeln(
        '    <div class="relative z-10 max-w-5xl mx-auto my-12 bg-white shadow-2xl rounded-lg border border-gray-200 p-10 md:p-16 page-container">');

    // Logo
    buffer
        .writeln('        <div class="text-center mb-8 flex justify-center">');
    buffer.writeln(
        '            <svg width="108" height="34" viewBox="0 0 108 34" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M13.129 15.344h6.014a6.74 6.74 0 0 0 6.74-6.737V.13h-9.258a3.5 3.5 0 0 0-3.496 3.496z" fill="#3EA3DC"/><path d="M10.254.13H3.498A3.5 3.5 0 0 0 0 3.628v19.864a3.493 3.493 0 0 0 3.496 3.495h5.012a1.75 1.75 0 0 0 1.749-1.747z" fill="#FC0"/><path d="M20.284 18.507h-7.155v6.736a1.75 1.75 0 0 0 1.749 1.747h7.632a3.366 3.366 0 0 0 3.365-3.363V15.51a6.72 6.72 0 0 1-5.591 2.997" fill="#86BC25"/><path d="M35.036.686a2.27 2.27 0 0 1 .683 1.672 2.22 2.22 0 0 1-.678 1.658 2.42 2.42 0 0 1-1.77.658 2.37 2.37 0 0 1-1.728-.663 2.22 2.22 0 0 1-.679-1.658 2.27 2.27 0 0 1 .68-1.672A2.34 2.34 0 0 1 33.271 0a2.4 2.4 0 0 1 1.764.685m.666 5.689h-4.818V26.84H35.7zm18.683-4.1q2.765 2.073 2.765 6.207 0 4.318-2.784 6.49-2.784 2.17-7.421 2.162H43.9v9.632h-4.966V.205h7.676q5 0 7.774 2.07M50.6 12.293q1.355-1.102 1.355-3.817 0-4.628-5.382-4.628H43.9v9.556h2.673q2.67.005 4.027-1.104zM71.091 6.11l-.828 4.664a7.3 7.3 0 0 0-1.768-.226c-1.18 0-2.027.563-2.786 1.261-.795.73-1.583 1.931-1.619 3.856v11.172h-4.817V6.375h4.178l.452 3.912q.714-2.145 2.074-3.292a4.7 4.7 0 0 1 3.125-1.147 7.2 7.2 0 0 1 1.99.263m17.481 9.745q0-4.741-2.297-7.393t-6.474-2.651q-2.748 0-4.742 1.381a8.7 8.7 0 0 0-3.049 3.8q-1.056 2.43-1.054 5.475 0 4.816 2.466 7.6 2.466 2.785 7.019 2.782 4.065 0 7.377-2.67l-.534-3.957q-.686.651-1.451 1.209c-.772.544-1.606.992-2.486 1.335a7.1 7.1 0 0 1-2.483.434q-2.107 0-3.387-1.242-1.281-1.242-1.506-4.146h12.495c.068-1.045.106-1.706.106-1.957m-4.78-1.16h-7.83q.187-2.862 1.186-4.158 1-1.298 2.765-1.298 3.877 0 3.877 5.229zm22.399-6.14Q108 11.303 108 16.267q0 3.087-.923 5.474-.922 2.388-2.71 3.743-1.789 1.354-4.234 1.354-3.162 0-5.012-2.181v8.035l-4.816.778V6.375h4.22l.263 2.446a7.8 7.8 0 0 1 2.673-2.256 6.96 6.96 0 0 1 3.161-.753q3.764-.003 5.57 2.744m-3.237 7.75q0-3.65-.94-5.267-.94-1.62-2.824-1.617c-.81.002-1.6.258-2.257.732a6.4 6.4 0 0 0-1.808 1.976v8.955q1.394 2.072 3.652 2.072 4.177 0 4.177-6.852" fill="#575756"/></svg>');
    buffer.writeln('        </div>');

    // Page Header
    buffer.writeln(
        '        <header class="flex flex-col md:flex-row justify-between items-start md:items-center border-b border-gray-200 pb-6 mb-8">');
    buffer.writeln('            <div>');
    buffer.writeln(
        '                <h1 class="text-3xl font-bold text-assessment-title">');
    buffer.writeln('                    Assessment: $topic');
    buffer.writeln('                </h1>');
    buffer.writeln(
        '                <div class="flex flex-wrap items-center gap-x-4 text-assessment-meta text-sm mt-3">');
    buffer.writeln(
        '                    <span><strong>Class:</strong> $grade</span>');
    buffer.writeln('                    <span class="text-gray-300">|</span>');
    buffer.writeln(
        '                    <span><strong>Subject:</strong> $subject</span>');
    buffer.writeln('                    <span class="text-gray-300">|</span>');
    buffer.writeln(
        '                    <span><strong>Questions:</strong> $numberOfQuestions</span>');
    buffer.writeln('                </div>');
    buffer.writeln('            </div>');
    buffer.writeln(
        '            <div class="text-left md:text-right text-assessment-meta text-sm mt-4 md:mt-0 flex-shrink-0">');
    buffer.writeln(
        '                <p><strong>Created By:</strong> Ankit Roy</p>');
    buffer.writeln(
        '                <p class="mt-1"><strong>Date:</strong> $formattedDate</p>');
    buffer.writeln('            </div>');
    buffer.writeln('        </header>');

    // Student Information Section
    buffer.writeln(
        '        <section class="mb-8 p-4 border border-gray-200 rounded-lg bg-gray-50">');
    buffer.writeln('            <div class="grid grid-cols-2 gap-4">');
    buffer.writeln(
        '                <div><label class="font-semibold text-assessment-dark">Name:</label> <span class="border-b-2 border-gray-300 inline-block w-32"></span></div>');
    buffer.writeln(
        '                <div><label class="font-semibold text-assessment-dark">Roll No:</label> <span class="border-b-2 border-gray-300 inline-block w-32"></span></div>');
    buffer.writeln('            </div>');
    buffer.writeln('        </section>');

    // Instructions Section
    buffer.writeln(
        '        <section class="mb-8 p-4 border-l-4 border-assessment-title bg-blue-50 rounded">');
    buffer.writeln(
        '            <h2 class="text-lg font-bold text-assessment-dark mb-3">Instructions:</h2>');
    buffer.writeln(
        '            <ul class="list-disc list-inside space-y-2 text-assessment-body text-sm">');
    buffer.writeln(
        '                <li>Please read each question carefully and select all correct options.</li>');
    buffer.writeln('                <li>All questions are compulsory.</li>');
    buffer.writeln(
        '                <li>Some question may have more than one correct option — select all that apply</li>');
    buffer.writeln('            </ul>');
    buffer.writeln('        </section>');

    // Questions Section
    buffer.writeln('        <main class="space-y-6">');

    int questionNumber = 1;

    // MCQ Single Answer
    questionNumber = _buildQuestionSet(
        buffer,
        "Multiple Choice Questions (Single Answer)",
        mcqSingleAnswer,
        "mcq_single_answer",
        questionNumber);

    // MCQ Multiple Answer
    questionNumber = _buildQuestionSet(
        buffer,
        "Multiple Choice Questions (Multiple Answer)",
        mcqMultipleAnswer,
        "mcq_multiple_answer",
        questionNumber);

    // True/False
    questionNumber = _buildQuestionSet(
        buffer, "True/False", trueFalse, "true_false", questionNumber);

    // Fill in the Blanks
    questionNumber = _buildQuestionSet(buffer, "Fill in the Blanks",
        fillInBlanks, "fill_in_blanks", questionNumber);

    // Match the Columns
    questionNumber = _buildQuestionSet(buffer, "Match the Columns",
        matchColumns, "match_the_columns", questionNumber);

    // Very Short Answer
    questionNumber = _buildQuestionSet(buffer, "Very Short Answer",
        veryShortAnswer, "very_short_answer", questionNumber);

    // Short Answer
    questionNumber = _buildQuestionSet(
        buffer, "Short Answer", shortAnswer, "short_answer", questionNumber);

    // Long Answer
    questionNumber = _buildQuestionSet(
        buffer, "Long Answer", longAnswer, "long_answer", questionNumber);

    buffer.writeln('        </main>');
    buffer.writeln('    </div>');
    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
  }

  /// Builds a set of questions of a specific type
  static int _buildQuestionSet(
    StringBuffer buffer,
    String setTitle,
    List questions,
    String questionType,
    int startingNumber,
  ) {
    if (questions.isEmpty) return startingNumber;

    buffer.writeln(
        '            <section class="border border-assessment-box rounded-lg overflow-hidden page-break">');

    // Section Header
    buffer.writeln(
        '                <header class="bg-assessment-header px-5 py-3 border-b border-assessment-box">');
    buffer.writeln(
        '                    <h2 class="text-base font-semibold text-assessment-dark">$setTitle</h2>');
    buffer.writeln('                </header>');

    // Questions
    buffer.writeln('                <div class="p-5 space-y-6">');

    int questionCount = startingNumber;
    for (final question in questions) {
      final Map<String, dynamic> q = question as Map<String, dynamic>? ?? {};
      _buildQuestionBlock(buffer, q, questionCount, questionType);
      questionCount++;
    }

    buffer.writeln('                </div>');
    buffer.writeln('            </section>');

    return questionCount;
  }

  /// Builds a single question block with options and tags
  static void _buildQuestionBlock(
    StringBuffer buffer,
    Map<String, dynamic> question,
    int questionNumber,
    String questionType,
  ) {
    final String questionText =
        _sanitizePreserveMath(_decodeUnicode(question["question"] ?? ""));
    final String answer =
        _sanitizePreserveMath(_decodeUnicode(question["answer"] ?? ""));
    final Map<String, dynamic> tags =
        question["tags"] as Map<String, dynamic>? ?? {};
    final String bloom = tags["bloom"] ?? "";
    final String difficulty = tags["difficulty"] ?? "";
    final String learningObjectives = tags["learning_objectives"] ?? "";

    final List options = question["options"] as List? ?? [];

    buffer
        .writeln('                <div class="pb-6 border-b border-gray-200">');
    buffer.writeln(
        '                    <div class="flex items-start gap-3 mb-3">');
    buffer.writeln(
        '                        <span class="font-bold text-assessment-title text-lg min-w-fit">Q$questionNumber</span>');
    buffer.writeln(
        '                        <p class="text-assessment-body text-sm leading-relaxed">$questionText</p>');
    buffer.writeln('                    </div>');

    // Options for MCQ types
    if (questionType.contains("mcq")) {
      buffer.writeln('                    <div class="ml-8 space-y-2">');
      for (int i = 0; i < options.length; i++) {
        final String optionText =
            _sanitizePreserveMath(_decodeUnicode(options[i].toString()));
        final String optionLabel = String.fromCharCode(65 + i); // A, B, C, D...
        buffer.writeln(
            '                        <p class="text-assessment-body text-sm"><strong>$optionLabel.</strong> $optionText</p>');
      }
      buffer.writeln('                    </div>');
    } else if (questionType == "match_the_columns") {
      // For match the columns, show options as matching pairs
      buffer.writeln('                    <div class="ml-8 space-y-2">');
      for (int i = 0; i < options.length; i++) {
        final String optionText =
            _sanitize(_decodeUnicode(options[i].toString()));
        buffer.writeln(
            '                        <p class="text-assessment-body text-sm">• $optionText</p>');
      }
      buffer.writeln('                    </div>');
    } else if (questionType == "fill_in_blanks") {
      // Show blank lines for fill in the blanks
      buffer.writeln('                    <div class="ml-8 mt-3">');
      buffer.writeln(
          '                        <div class="border-b-2 border-gray-400 w-48 h-6"></div>');
      buffer.writeln('                    </div>');
    }

    // Answer section
    // Answer section with bulb icon and learning objectives
    buffer.writeln(
        '                    <div class="mt-4 p-4 bg-[#F8FFEE] rounded-lg border-2 border-[#8AC926]">');
    buffer.writeln(
        '                        <div class="flex items-start gap-3">');
    buffer.writeln('                            <div class="flex-shrink-0">');
    buffer.writeln('                                <!-- Bulb SVG -->');
    buffer.writeln(
        '                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">');
    buffer.writeln(
        '                                  <g clip-path="url(#a)" fill-rule="evenodd" clip-rule="evenodd">');
    buffer.writeln(
        '                                    <path d="M9.491 20.02a.335.335 0 0 1-.323-.309c-.281-3.22-1.322-4.724-2.235-6.074-.746-1.068-1.378-2.01-1.378-3.529 0-3.557 2.896-6.439 6.44-6.439 3.556 0 6.453 2.882 6.453 6.44 0 1.518-.647 2.446-1.378 3.514-.928 1.322-1.969 2.84-2.25 6.088a.33.33 0 0 1-.351.31.336.336 0 0 1-.296-.352H9.815a.336.336 0 0 1-.295.351z" fill="#fdc500"/>');
    buffer.writeln(
        '                                    <path d="M12.51 23.986h-1.04a2.32 2.32 0 0 1-2.306-2.32v-1.982c0-.183.14-.324.323-.324.127 0 .24.07.296.183h4.415a.33.33 0 0 1 .295-.183c.182 0 .323.14.323.324v1.982a2.31 2.31 0 0 1-2.306 2.32" fill="#212121"/>');
    buffer.writeln(
        '                                    <path d="M15.117 19.867H8.888a.33.33 0 0 1-.337-.323c0-.183.154-.338.337-.338h6.229a.33.33 0 0 1 .323.338c0 .182-.14.323-.323.323m0 1.209H8.888a.34.34 0 0 1-.337-.338c0-.168.154-.323.337-.323h6.229c.182 0 .323.155.323.323a.33.33 0 0 1-.323.338m0 1.196H8.888a.33.33 0 0 1-.337-.324.33.33 0 0 1 .337-.323h6.229c.182 0 .323.14.323.323s-.14.324-.323.324" fill="#212121"/>');
    buffer.writeln(
        '                                    <path d="M7.237 10.209a.32.32 0 0 1-.323-.324A5.08 5.08 0 0 1 11.99 4.81a.33.33 0 0 1 .337.323.33.33 0 0 1-.337.323c-2.433 0-4.415 1.997-4.415 4.43a.33.33 0 0 1-.338.323" fill="#fefefe"/>');
    buffer.writeln(
        '                                    <path d="M11.991 2.812a.32.32 0 0 1-.323-.324V.337c0-.183.14-.323.323-.323a.33.33 0 0 1 .338.323v2.151a.33.33 0 0 1-.338.324m4.683 1.265a.27.27 0 0 1-.169-.057.306.306 0 0 1-.112-.435l1.068-1.87a.343.343 0 0 1 .45-.127.343.343 0 0 1 .127.45l-1.083 1.87a.34.34 0 0 1-.281.169" fill="#fdc500"/>');
    buffer.writeln(
        '                                  </g><defs><clipPath id="a"><path fill="#fff" d="M0 0h24v24H0z"/></clipPath></defs></svg>');
    buffer.writeln('                            </div>');
    buffer.writeln('                            <div>');
    buffer.writeln(
        '                                <p class="text-sm font-semibold text-assessment-dark mb-2">Answer - $answer</p>');
    if (learningObjectives.isNotEmpty) {
      final String los =
          _sanitizePreserveMath(_decodeUnicode(learningObjectives));
      buffer.writeln(
          '                                <p class="text-sm text-assessment-body mb-2"><strong>Learning Objectives (LOs)-</strong> $los</p>');
    }
    buffer.writeln('                            </div>');
    buffer.writeln('                        </div>');
    buffer.writeln(
        '                        <div class="flex flex-wrap gap-2 mt-3">');
    // tags moved inside the answer box
    if (difficulty.isNotEmpty) {
      buffer.writeln(
          '                            <span class="difficulty-tag px-3 py-1 text-xs rounded-full font-semibold">Difficulty Level: $difficulty</span>');
    }
    if (bloom.isNotEmpty) {
      buffer.writeln(
          '                            <span class="bloom-tag px-3 py-1 text-xs rounded-full font-semibold">Bloom: $bloom</span>');
    }
    buffer.writeln('                        </div>');
    buffer.writeln('                    </div>');

    // Tags
    buffer
        .writeln('                    <div class="flex flex-wrap gap-2 mt-3">');
    // if (bloom.isNotEmpty) {
    //   buffer.writeln(
    //       '                        <span class="bloom-tag px-2 py-1 text-xs rounded-full font-semibold">Bloom: $bloom</span>');
    // }
    // if (difficulty.isNotEmpty) {
    //   buffer.writeln(
    //       '                        <span class="difficulty-tag px-2 py-1 text-xs rounded-full font-semibold">Difficulty: $difficulty</span>');
    // }
    // if (learningObjectives.isNotEmpty) {
    //   final String losPreview = learningObjectives.length > 30
    //       ? learningObjectives.substring(0, 30)
    //       : learningObjectives;
    //   buffer.writeln(
    //       '                        <span class="learning-obj-tag px-2 py-1 text-xs rounded-full font-semibold">Learning Objectives: $losPreview...</span>');
    // }
    buffer.writeln('                    </div>');

    buffer.writeln('                </div>');
  }

  /// Triggers a download/save dialog for the generated HTML content.
  static Future<String?> downloadHtml(String htmlContent, String topic) async {
    try {
      final String safeTopic = topic.replaceAll(RegExp(r'[^\w\s-]'), '_');
      final String fileName = 'Assessment-$safeTopic.html';

      final Uint8List bytes = Uint8List.fromList(utf8.encode(htmlContent));

      final savedPath =
          await FileDownloadService.saveBytesToDownloads(bytes, fileName);
      return savedPath;
    } catch (e) {
      debugPrint('Error saving HTML file: $e');
      rethrow;
    }
  }

  /// Decodes Unicode escape sequences in a string.
  static String _decodeUnicode(String s) => s.replaceAllMapped(
        RegExp(r'\\u([0-9a-fA-F]{4})'),
        (Match m) => String.fromCharCode(int.parse(m.group(1)!, radix: 16)),
      );

  /// Sanitizes text but preserves LaTeX/math blocks so client-side
  /// renderers like KaTeX can process them. Math blocks preserved:
  /// $$...$$, $...$, \(...\), \[...\]
  static String _sanitizePreserveMath(String input) {
    if (input.isEmpty) return input;

    final List<String> mathBlocks = [];
    String temp = input;

    final patterns = [
      RegExp(r'\$\$(.+?)\$\$', dotAll: true),
      RegExp(r'\$(.+?)\$', dotAll: true),
      RegExp(r'\\\\\((.+?)\\\\\)', dotAll: true),
      RegExp(r'\\\\\[(.+?)\\\\\]', dotAll: true),
    ];

    for (final p in patterns) {
      temp = temp.replaceAllMapped(p, (m) {
        mathBlocks.add(m[0]!);
        return '___MATH_BLOCK_${mathBlocks.length - 1}___';
      });
    }

    String sanitized = _sanitize(temp);

    for (int i = 0; i < mathBlocks.length; i++) {
      sanitized = sanitized.replaceAll('___MATH_BLOCK_${i}___', mathBlocks[i]);
    }

    return sanitized;
  }

  /// Render simple LaTeX-like math into plain readable text.
  /// Removes delimiters like $...$, \(...\), and converts common commands
  /// such as \frac{a}{b} -> a/b and \theta -> θ. This is intentionally
  /// conservative (no MathJax); it aims to produce readable inline math.
  // ignore: unused_element
  static String _renderMathPlain(String s) {
    if (s.isEmpty) return s;

    String out = s;

    // Remove common delimiters
    out = out.replaceAll(r'\\(', '');
    out = out.replaceAll(r'\\)', '');
    out = out.replaceAll(r'\\[', '');
    out = out.replaceAll(r'\\]', '');
    // Remove dollar delimiters
    out = out.replaceAll(r'\$\$', '');
    out = out.replaceAll(r'\$', '');

    // Repeatedly replace \frac{a}{b} with a/b
    final fracReg = RegExp(r'\\frac\{([^}]*)\}\{([^}]*)\}');
    while (fracReg.hasMatch(out)) {
      out = out.replaceAllMapped(fracReg, (m) => '${m[1]}/${m[2]}');
    }

    // Replace common LaTeX commands with unicode or plain text
    final replacements = {
      r'\\theta': 'θ',
      r'\\alpha': 'α',
      r'\\beta': 'β',
      r'\\gamma': 'γ',
      r'\\delta': 'δ',
      r'\\pi': 'π',
      r'\\lambda': 'λ',
      r'\\mu': 'μ',
      r'\\sigma': 'σ',
      r'\\phi': 'φ',
      r'\\omega': 'ω',
      r'\\times': '×',
      r'\\pm': '±',
      r'\\leq': '≤',
      r'\\geq': '≥',
      r'\\neq': '≠',
      r'\\sqrt': '√',
      r'\\cdot': '·',
    };

    replacements.forEach((k, v) {
      out = out.replaceAll(RegExp(k), v);
    });

    // Convert common trig/function commands by stripping the backslash
    out = out.replaceAllMapped(RegExp(r'\\([a-zA-Z]+)'), (m) => m[1] ?? '');

    // Convert superscript braces like ^{2} -> superscript digit if possible
    Map<String, String> superDigits = {
      '0': '⁰',
      '1': '¹',
      '2': '²',
      '3': '³',
      '4': '⁴',
      '5': '⁵',
      '6': '⁶',
      '7': '⁷',
      '8': '⁸',
      '9': '⁹',
    };

    out = out.replaceAllMapped(RegExp(r'\^\{([^}]*)\}'), (m) {
      final content = m[1] ?? '';
      return content.split('').map((ch) => superDigits[ch] ?? ch).join();
    });
    // caret followed by single digit
    out = out.replaceAllMapped(
        RegExp(r'\^([0-9])'), (m) => superDigits[m[1]] ?? m[1]!);

    // Finally normalize multiple spaces
    out = out.replaceAll(RegExp(r'\s+'), ' ').trim();

    return out;
  }

  /// Simple HTML sanitizer to prevent injection issues
  static String _sanitize(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }
}
