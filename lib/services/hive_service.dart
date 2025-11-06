import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lessonplan/models/lesson_plan_history_model.dart';

class HiveService {
  static const String _boxName = 'lessonPlanHistoryBox';
  static Box<LessonPlanHistoryModel>? _box;

  /// Initialize Hive and open the lesson plan history box
  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      
      // Register the adapter
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(LessonPlanHistoryModelAdapter());
      }

      // Open the box
      _box = await Hive.openBox<LessonPlanHistoryModel>(_boxName);
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
        throw Exception('Hive box not initialized. Call HiveService.init() first.');
      }
      await _box!.add(lessonPlan);
      log('Lesson plan saved to history: ${lessonPlan.lessonPlanID}');
    } catch (e) {
      log('Error saving lesson plan to history: $e');
      rethrow;
    }
  }

  /// Get all lesson plans from history
  static List<LessonPlanHistoryModel> getAllLessonPlans() {
    try {
      if (_box == null) {
        throw Exception('Hive box not initialized. Call HiveService.init() first.');
      }
      return _box!.values.toList();
    } catch (e) {
      log('Error getting lesson plans from history: $e');
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

  /// Get a specific lesson plan by ID
  static LessonPlanHistoryModel? getLessonPlanById(String lessonPlanID) {
    try {
      if (_box == null) {
        throw Exception('Hive box not initialized. Call HiveService.init() first.');
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

  /// Delete a lesson plan from history
  static Future<void> deleteLessonPlan(String lessonPlanID) async {
    try {
      if (_box == null) {
        throw Exception('Hive box not initialized. Call HiveService.init() first.');
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
        throw Exception('Hive box not initialized. Call HiveService.init() first.');
      }
      await _box!.clear();
      log('All lesson plan history cleared');
    } catch (e) {
      log('Error clearing lesson plan history: $e');
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
}

