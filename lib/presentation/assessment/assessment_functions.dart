import 'dart:convert';
import 'package:lessonplan/presentation/lessonplan/functions.dart' as lp;

class AssessmentHtmlGenerator {
  static Future<String> generateAssessmentHtml(
      Map<String, dynamic> data) async {
    final buffer = StringBuffer();

    final String topic =
        data['topic'] ?? data['topic_name'] ?? 'Untitled Assessment';
    final String grade = data['grade']?['name'] ?? 'N/A';
    final String subject = data['subject']?['name'] ?? 'N/A';
    final int numberOfQuestions = data['number_of_questions'] ?? 0;

    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="en">');
    buffer.writeln('<head>');
    buffer.writeln('<meta charset="utf-8"/>');
    buffer.writeln(
        '<meta name="viewport" content="width=device-width, initial-scale=1"/>');
    buffer.writeln('<title>Worksheet: ${_sanitize(topic)}</title>');
    buffer.writeln(
        '<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">');
    buffer.writeln(
        '<style>body{font-family:Inter, sans-serif;margin:24px;color:#222}h1{color:#0b57a4} .meta{color:#666;margin-bottom:12px} .question{margin:12px 0;padding:12px;border:1px solid #e6e6e6;border-radius:6px} .q-type{font-weight:600;color:#0b57a4}</style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');
    buffer.writeln('<h1>Worksheet: ${_sanitize(topic)}</h1>');
    buffer.writeln('<div class="meta">');
    buffer.writeln('<div>Grade: ${_sanitize(grade)}</div>');
    buffer.writeln('<div>Subject: ${_sanitize(subject)}</div>');
    buffer.writeln('<div>Number of Questions: ${numberOfQuestions}</div>');
    buffer.writeln('</div>');

    // Subject matter & learning standards
    if (data['subject_matter'] != null) {
      buffer.writeln('<h2>Subject Matter</h2>');
      buffer.writeln(
          '<pre>${_sanitize(_decodeUnicode(jsonEncode(data['subject_matter'])))}</pre>');
    }

    if (data['learning_standards'] != null) {
      buffer.writeln('<h2>Learning Standards</h2>');
      buffer.writeln(
          '<pre>${_sanitize(_decodeUnicode(jsonEncode(data['learning_standards'])))}</pre>');
    }

    // Question configuration summary (if any)
    if (data['question_configuration'] != null) {
      buffer.writeln('<h2>Question Configuration</h2>');
      buffer.writeln(
          '<pre>${_sanitize(_decodeUnicode(jsonEncode(data['question_configuration'])))}</pre>');
    }

    // Final generated questions
    if (data['questions'] != null) {
      buffer.writeln('<h2>Generated Questions</h2>');
      final questions = data['questions'] as Map<String, dynamic>;
      for (final entry in questions.entries) {
        final qType = entry.key;
        final list = entry.value as List<dynamic>;
        for (final q in list) {
          buffer.writeln('<div class="question">');
          buffer.writeln('<div class="q-type">${_sanitize(qType)}</div>');
          buffer.writeln(
              '<div class="q-text">${_sanitize(_decodeUnicode(q['question']?.toString() ?? ''))}</div>');
          if (q['options'] != null) {
            buffer.writeln('<ul>');
            for (final opt in q['options']) {
              buffer.writeln(
                  '<li>${_sanitize(_decodeUnicode(opt.toString()))}</li>');
            }
            buffer.writeln('</ul>');
          }
          if (q['answer'] != null) {
            buffer.writeln(
                '<div class="answer"><strong>Answer:</strong> ${_sanitize(_decodeUnicode(q['answer'].toString()))}</div>');
          }
          buffer.writeln('</div>');
        }
      }
    }

    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
  }

  static Future<void> downloadHtml(String htmlContent, String topic) async {
    // reuse the lessonplan helper to save html bytes via FileSaver
    await lp.HtmlGenerator.downloadHtml(htmlContent, topic);
  }

  /// Decodes Unicode escape sequences in a string.
  /// For example, \u221a5 becomes √5
  static String _decodeUnicode(String s) => s.replaceAllMapped(
        RegExp(r'\\u([0-9a-fA-F]{4})'),
        (Match m) => String.fromCharCode(int.parse(m.group(1)!, radix: 16)),
      );

  static String _sanitize(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;');
  }
}
