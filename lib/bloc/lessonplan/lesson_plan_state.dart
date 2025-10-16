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

class LessonPlanGenerationFailedState extends LessonPlanState {
  final LessonPlanStatus status;

  LessonPlanGenerationFailedState({
    required this.status,
  });
}

class LessonPlanGenerationState extends LessonPlanState {
  final LessonPlanStatus status;

  LessonPlanGenerationState({
    required this.status,
  });
}
