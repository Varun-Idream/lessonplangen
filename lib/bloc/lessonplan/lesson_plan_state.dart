part of 'lesson_plan_cubit.dart';

abstract class LessonPlanState {}

class LessonPlanInitialState extends LessonPlanState {}

class LessonPlanAuthState extends LessonPlanState {}

class LessonPlanAuthFailedState extends LessonPlanState {}

class LessonPlanBoardsState extends LessonPlanState {
  final List<Board> boards;

  LessonPlanBoardsState({
    required this.boards,
  });
}

class LessonPlanBoardsFailedState extends LessonPlanState {}

class LessonPlanGradesState extends LessonPlanState {
  final List<Grade> grades;

  LessonPlanGradesState({
    required this.grades,
  });
}

class LessonPlanGradesFailedState extends LessonPlanState {}

class LessonPlanSubjectsState extends LessonPlanState {
  final List<Subject> subjects;

  LessonPlanSubjectsState({
    required this.subjects,
  });
}

class LessonPlanSubjectsFailedState extends LessonPlanState {}

class LessonPlanGeneration extends LessonPlanState {
  final String lessonPlanID;
  final Map<String, dynamic> data;
  final LessonPlanStatus status;

  LessonPlanGeneration({
    required this.lessonPlanID,
    required this.data,
    required this.status,
  });
}

class LessonPlanLoadingState extends LessonPlanState {
  final LessonPlanStatus status;

  LessonPlanLoadingState({
    required this.status,
  });
}

class LessonPlanFailure extends LessonPlanState {
  final LessonPlanStatus status;
  final String failureMessage;

  LessonPlanFailure({
    required this.status,
    required this.failureMessage,
  });
}