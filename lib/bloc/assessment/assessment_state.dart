part of 'assessment_cubit.dart';

abstract class AssessmentState {}

class AssessmentInitialState extends AssessmentState {}

class AssessmentAuthState extends AssessmentState {}

class AssessmentAuthFailedState extends AssessmentState {}

class AssessmentBoardsState extends AssessmentState {
  final List<Board> boards;

  AssessmentBoardsState({
    required this.boards,
  });
}

class AssessmentBoardsFailedState extends AssessmentState {}

class AssessmentGradesState extends AssessmentState {
  final List<Grade> grades;

  AssessmentGradesState({
    required this.grades,
  });
}

class AssessmentGradesFailedState extends AssessmentState {}

class AssessmentSubjectsState extends AssessmentState {
  final List<Subject> subjects;

  AssessmentSubjectsState({
    required this.subjects,
  });
}

class AssessmentSubjectsFailedState extends AssessmentState {}

class AssessmentGeneration extends AssessmentState {
  final String assessmentID;
  final Map<String, dynamic> data;
  final AssessmentGenStatus status;

  AssessmentGeneration({
    required this.assessmentID,
    required this.data,
    required this.status,
  });
}

class AssessmentLoadingState extends AssessmentState {
  final AssessmentGenStatus status;

  AssessmentLoadingState({
    required this.status,
  });
}

class AssessmentFailure extends AssessmentState {
  final AssessmentGenStatus status;
  final String failureMessage;

  AssessmentFailure({
    required this.status,
    required this.failureMessage,
  });
}
