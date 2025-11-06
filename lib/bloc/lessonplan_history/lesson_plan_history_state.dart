part of 'lesson_plan_history_cubit.dart';


abstract class LessonPlanHistoryState {}

class LessonPlanHistoryInitialState extends LessonPlanHistoryState {}

class LessonPlanHistoryLoadingState extends LessonPlanHistoryState {}

class LessonPlanHistoryLoadedState extends LessonPlanHistoryState {
  final List<LessonPlanHistoryModel> history;

  LessonPlanHistoryLoadedState({required this.history});
}

class LessonPlanHistoryErrorState extends LessonPlanHistoryState {
  final String errorMessage;

  LessonPlanHistoryErrorState({required this.errorMessage});
}

