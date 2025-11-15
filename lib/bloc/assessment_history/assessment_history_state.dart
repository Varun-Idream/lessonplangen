part of 'assessment_history_cubit.dart';


abstract class AssessmentHistoryState {}

class AssessmentHistoryInitialState extends AssessmentHistoryState {}

class AssessmentHistoryLoadingState extends AssessmentHistoryState {}

class AssessmentHistoryLoadedState extends AssessmentHistoryState {
  final List<AssessmentHistoryModel> history;

  AssessmentHistoryLoadedState({required this.history});
}

class AssessmentHistoryErrorState extends AssessmentHistoryState {
  final String errorMessage;

  AssessmentHistoryErrorState({required this.errorMessage});
}

