import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lessonplan/models/assessment_history_model.dart';
import 'package:lessonplan/services/hive_service.dart';

part 'assessment_history_state.dart';

class AssessmentHistoryCubit extends Cubit<AssessmentHistoryState> {
  AssessmentHistoryCubit() : super(AssessmentHistoryInitialState());

  List<AssessmentHistoryModel> _allHistory = [];
  List<AssessmentHistoryModel> _filteredHistory = [];

  /// Load all lesson plan history from Hive
  void loadHistory() async {
    try {
      emit(AssessmentHistoryLoadingState());

      _allHistory = HiveService.getAssessmentsSorted();
      _filteredHistory = List.from(_allHistory);

      emit(AssessmentHistoryLoadedState(history: _filteredHistory));
    } catch (e) {
      log('Error loading lesson plan history: $e');
      emit(AssessmentHistoryErrorState(
          errorMessage: 'Failed to load history: $e'));
    }
  }

  /// Filter history by class/grade
  void filterByClass(String? gradeName) {
    if (gradeName == null || gradeName == 'All Class') {
      _filteredHistory = List.from(_allHistory);
    } else {
      _filteredHistory =
          _allHistory.where((item) => item.gradeName == gradeName).toList();
    }
    emit(AssessmentHistoryLoadedState(history: _filteredHistory));
  }

  /// Filter history by subject
  void filterBySubject(String? subjectName) {
    if (subjectName == null || subjectName == 'All Subject') {
      _filteredHistory = List.from(_allHistory);
    } else {
      _filteredHistory =
          _allHistory.where((item) => item.subjectName == subjectName).toList();
    }
    emit(AssessmentHistoryLoadedState(history: _filteredHistory));
  }

  /// Apply multiple filters
  void applyFilters({
    String? gradeName,
    String? subjectName,
    String? searchQuery,
  }) {
    _filteredHistory = List.from(_allHistory);

    // Filter by grade
    if (gradeName != null && gradeName != 'All Class') {
      _filteredHistory = _filteredHistory
          .where((item) => item.gradeName == gradeName)
          .toList();
    }

    // Filter by subject
    if (subjectName != null && subjectName != 'All Subject') {
      _filteredHistory = _filteredHistory
          .where((item) => item.subjectName == subjectName)
          .toList();
    }

    // Search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      _filteredHistory = _filteredHistory.where((item) {
        final grade = item.gradeName?.toLowerCase() ?? '';
        final subject = item.subjectName?.toLowerCase() ?? '';
        final topics = item.topics?.toLowerCase() ?? '';
        final chapter = _getChapterFromData(item.data)?.toLowerCase() ?? '';

        return grade.contains(query) ||
            subject.contains(query) ||
            topics.contains(query) ||
            chapter.contains(query);
      }).toList();
    }

    emit(AssessmentHistoryLoadedState(history: _filteredHistory));
  }

  /// Get unique list of grades from history
  List<String> getUniqueGrades() {
    final grades = _allHistory
        .where((item) => item.gradeName != null && item.gradeName!.isNotEmpty)
        .map((item) => item.gradeName!)
        .toSet()
        .toList();
    grades.sort();
    return grades;
  }

  /// Get unique list of subjects from history
  List<String> getUniqueSubjects() {
    final subjects = _allHistory
        .where(
            (item) => item.subjectName != null && item.subjectName!.isNotEmpty)
        .map((item) => item.subjectName!)
        .toSet()
        .toList();
    subjects.sort();
    return subjects;
  }

  /// Extract chapter from data
  String? _getChapterFromData(Map<String, dynamic> data) {
    try {
      // Try different possible keys for chapter
      if (data.containsKey('chapter')) {
        return data['chapter']?.toString();
      }
      if (data.containsKey('chapter_name')) {
        return data['chapter_name']?.toString();
      }
      if (data.containsKey('metadata')) {
        final metadata = data['metadata'];
        if (metadata is Map && metadata.containsKey('chapter')) {
          return metadata['chapter']?.toString();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get chapter from history item
  String? getChapter(AssessmentHistoryModel item) {
    return _getChapterFromData(item.data);
  }

  /// Get creator from data (if available)
  String? getCreator(AssessmentHistoryModel item) {
    try {
      final data = item.data;
      if (data.containsKey('creator')) {
        return data['creator']?.toString();
      }
      if (data.containsKey('created_by')) {
        return data['created_by']?.toString();
      }
      if (data.containsKey('metadata')) {
        final metadata = data['metadata'];
        if (metadata is Map && metadata.containsKey('creator')) {
          return metadata['creator']?.toString();
        }
      }
      return 'System'; // Default creator
    } catch (e) {
      return 'System';
    }
  }

  /// Delete a lesson plan from history
  void deleteAssessment(String assessmentID) async {
    try {
      await HiveService.deleteAssessment(assessmentID);
      loadHistory(); // Reload history after deletion
    } catch (e) {
      log('Error deleting lesson plan: $e');
      emit(AssessmentHistoryErrorState(errorMessage: 'Failed to delete: $e'));
    }
  }

  /// Refresh history
  void refreshHistory() {
    loadHistory();
  }
}
