import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lessonplan/models/lesson_plan_history_model.dart';
import 'package:lessonplan/models/assessment_history_model.dart';

class HiveService {
  static const String _boxName = 'lessonPlanHistoryBox';
  static Box<LessonPlanHistoryModel>? _box;
  static const String _assessmentBoxName = 'assessmentHistoryBox';
  static Box<AssessmentHistoryModel>? _assessmentBox;

  /// Initialize Hive and open the lesson plan history box
  static Future<void> init() async {
    try {
      await Hive.initFlutter();

      // Register the adapter
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(LessonPlanHistoryModelAdapter());
      }

      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(AssessmentHistoryModelAdapter());
      }

      // Open the box
      _box = await Hive.openBox<LessonPlanHistoryModel>(_boxName);
      _assessmentBox =
          await Hive.openBox<AssessmentHistoryModel>(_assessmentBoxName);
      log('Hive initialized successfully');
    } catch (e) {
      log('Error initializing Hive: $e');
      rethrow;
    }
  }

  /// Save a lesson plan to history
  static Future<void> saveLessonPlan(LessonPlanHistoryModel lessonPlan) async {
    try {
      if (_box == null) {
        throw Exception(
            'Hive box not initialized. Call HiveService.init() first.');
      }
      await _box!.add(lessonPlan);
      log('Lesson plan saved to history: ${lessonPlan.lessonPlanID}');
    } catch (e) {
      log('Error saving lesson plan to history: $e');
      rethrow;
    }
  }

  /// Save an assessment to history
  static Future<void> saveAssessment(AssessmentHistoryModel assessment) async {
    try {
      if (_assessmentBox == null) {
        throw Exception(
            'Assessment Hive box not initialized. Call HiveService.init() first.');
      }
      await _assessmentBox!.add(assessment);
      log('Assessment saved to history: ${assessment.assessmentID}');
    } catch (e) {
      log('Error saving assessment to history: $e');
      rethrow;
    }
  }

  /// Get all lesson plans from history
  static List<LessonPlanHistoryModel> getAllLessonPlans() {
    try {
      if (_box == null) {
        throw Exception(
            'Hive box not initialized. Call HiveService.init() first.');
      }
      return _box!.values.toList();
    } catch (e) {
      log('Error getting lesson plans from history: $e');
      return [];
    }
  }

  /// Get all assessments from history
  static List<AssessmentHistoryModel> getAllAssessments() {
    try {
      if (_assessmentBox == null) {
        throw Exception(
            'Assessment Hive box not initialized. Call HiveService.init() first.');
      }
      return _assessmentBox!.values.toList();
    } catch (e) {
      log('Error getting assessments from history: $e');
      return [];
    }
  }

  /// Get lesson plans sorted by creation date (newest first)
  static List<LessonPlanHistoryModel> getLessonPlansSorted() {
    try {
      final plans = getAllLessonPlans();
      plans.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return plans;
    } catch (e) {
      log('Error getting sorted lesson plans: $e');
      return [];
    }
  }

  /// Get assessments sorted by creation date (newest first)
  static List<AssessmentHistoryModel> getAssessmentsSorted() {
    try {
      final items = getAllAssessments();
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    } catch (e) {
      log('Error getting sorted assessments: $e');
      return [];
    }
  }

  /// Get a specific lesson plan by ID
  static LessonPlanHistoryModel? getLessonPlanById(String lessonPlanID) {
    try {
      if (_box == null) {
        throw Exception(
            'Hive box not initialized. Call HiveService.init() first.');
      }
      return _box!.values.firstWhere(
        (plan) => plan.lessonPlanID == lessonPlanID,
        orElse: () => throw Exception('Lesson plan not found'),
      );
    } catch (e) {
      log('Error getting lesson plan by ID: $e');
      return null;
    }
  }

  /// Get a specific assessment by ID
  static AssessmentHistoryModel? getAssessmentById(String assessmentID) {
    try {
      if (_assessmentBox == null) {
        throw Exception(
            'Assessment Hive box not initialized. Call HiveService.init() first.');
      }
      for (final item in _assessmentBox!.values) {
        if (item.assessmentID == assessmentID) return item;
      }
      return null;
    } catch (e) {
      log('Error getting assessment by ID: $e');
      return null;
    }
  }

  /// Delete a lesson plan from history
  static Future<void> deleteLessonPlan(String lessonPlanID) async {
    try {
      if (_box == null) {
        throw Exception(
            'Hive box not initialized. Call HiveService.init() first.');
      }
      final plan = getLessonPlanById(lessonPlanID);
      if (plan != null) {
        await plan.delete();
        log('Lesson plan deleted from history: $lessonPlanID');
      }
    } catch (e) {
      log('Error deleting lesson plan from history: $e');
      rethrow;
    }
  }

  /// Clear all lesson plan history
  static Future<void> clearAllHistory() async {
    try {
      if (_box == null) {
        throw Exception(
            'Hive box not initialized. Call HiveService.init() first.');
      }
      await _box!.clear();
      log('All lesson plan history cleared');
    } catch (e) {
      log('Error clearing lesson plan history: $e');
      rethrow;
    }
  }

  /// Delete an assessment from history
  static Future<void> deleteAssessment(String assessmentID) async {
    try {
      if (_assessmentBox == null) {
        throw Exception(
            'Assessment Hive box not initialized. Call HiveService.init() first.');
      }
      final assessment = getAssessmentById(assessmentID);
      if (assessment != null) {
        // HiveObject allows delete(), but in case it's not attached, find key and delete
        var foundKey;
        for (final k in _assessmentBox!.keys) {
          final v = _assessmentBox!.get(k);
          if (v != null && v.assessmentID == assessmentID) {
            foundKey = k;
            break;
          }
        }
        if (foundKey != null) await _assessmentBox!.delete(foundKey);
      }
    } catch (e) {
      log('Error deleting assessment from history: $e');
      rethrow;
    }
  }

  /// Get the count of lesson plans in history
  static int getHistoryCount() {
    try {
      if (_box == null) {
        return 0;
      }
      return _box!.length;
    } catch (e) {
      log('Error getting history count: $e');
      return 0;
    }
  }

  /// Get the count of assessments in history
  static int getAssessmentHistoryCount() {
    try {
      if (_assessmentBox == null) {
        throw Exception(
            'Assessment Hive box not initialized. Call HiveService.init() first.');
      }
      return _assessmentBox!.length;
    } catch (e) {
      log('Error getting assessment history count: $e');
      return 0;
    }
  }
}
