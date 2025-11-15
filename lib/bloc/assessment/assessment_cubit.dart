import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lessonplan/config/config_reader.dart';
import 'package:lessonplan/models/form_data_models.dart';
import 'package:lessonplan/models/assessment_history_model.dart';
import 'package:lessonplan/presentation/assessment/functions.dart';
import 'package:lessonplan/services/api/api.service.dart';
import 'package:lessonplan/services/hive_service.dart';
import 'package:lessonplan/util/constants/constants.dart';

part 'assessment_state.dart';

class AssessmentCubit extends Cubit<AssessmentState> {
  AssessmentCubit() : super(AssessmentInitialState());

  Timer? pollingTimer;

  // Store metadata for saving history later
  String? _currentBoardName;
  String? _currentGradeName;
  String? _currentSubjectName;
  String? _currentNumberOfQuestions;
  String? _currentTopic;

  void authenticateUser() async {
    try {
      final options = Options(
        headers: {
          'Content-type': "application/www-form-urlencoded",
        },
      );

      final data = FormData.fromMap(
        {
          'username': ConfigReader.config.cgfUsername,
          'password': ConfigReader.config.cgfPassword,
        },
        ListFormat.multi,
        false,
        'WebkitBoundry198439202-------------',
      );

      final response = await ApiService.cgfDio.post(
        "/token",
        options: options,
        data: data,
      );

      if (response.statusCode != 200) {
        throw "Authentication Failed: Check your API credentials.";
      }

      ApiService.configureCGF(token: response.data['access_token']);
      emit(AssessmentAuthState());
    } catch (e) {
      log('$e');
      emit(AssessmentAuthFailedState());
    }
  }

  void fetchBoards() async {
    try {
      final response = await ApiService.cgfDio.get("/metadata/v1/board");
      if (response.statusCode != 200) {
        throw "Error Occured While Featching Boards";
      }

      final List boardsData = response.data;
      final boards = boardsData
          .map((data) => Board(uuid: data['id'], name: data['name']))
          .toList();

      emit(AssessmentBoardsState(boards: boards));
    } catch (e) {
      log('$e');
      emit(AssessmentBoardsFailedState());
    }
  }

  void fetchGrades({
    required Board board,
  }) async {
    try {
      final response = await ApiService.cgfDio
          .get("/metadata/v1/board/${board.uuid}/grades");

      if (response.statusCode != 200) {
        throw "Error Occured While Featching Grades";
      }

      final List gradesData = response.data;
      final grades = gradesData
          .map((data) => Grade(uuid: data['id'], name: data['name']))
          .toList();

      emit(AssessmentGradesState(grades: grades));
    } catch (e) {
      log('$e');
      emit(AssessmentGradesFailedState());
    }
  }

  void fetchSubjects({
    required Board board,
    required Grade grade,
  }) async {
    try {
      final response = await ApiService.cgfDio.get(
        "/metadata/v1/board/${board.uuid}/grades/${grade.uuid}/subjects",
      );

      if (response.statusCode != 200) {
        throw "Error Occured While Featching Subjects";
      }

      List subjectsData = response.data;
      final subjects = subjectsData
          .map((data) => Subject(uuid: data['id'], name: data['name']))
          .toList();

      emit(AssessmentSubjectsState(subjects: subjects));
    } catch (e) {
      log('$e');
      emit(AssessmentSubjectsFailedState());
    }
  }

  void generateAssessment({
    required String boarduuid,
    required String gradeuuid,
    required String subjectuuid,
    required int numberOfQuestions,
    String? topic,
    String? section,
    required String boardName,
    required String gradeName,
    required String subjectName,
    required Map<String, int>? questionDistribution,
  }) async {
    // store metadata for saving history later
    _currentBoardName = boardName;
    _currentGradeName = gradeName;
    _currentSubjectName = subjectName;
    _currentNumberOfQuestions = numberOfQuestions.toString();
    _currentTopic = topic;

    try {
      emit(
        AssessmentLoadingState(
          status: AssessmentGenStatus.metaDataPostLoading,
        ),
      );

      // Default distributions
      final qd = questionDistribution ??
          {
            'multiple_choice': (numberOfQuestions * 0.5).toInt(),
            'true_false': (numberOfQuestions * 0.3).toInt(),
            'short_answer': (numberOfQuestions * 0.2).toInt(),
          };

      final difficultyDistribution = {
        'easy': 30,
        'medium': 50,
        'hard': 20,
      };

      final bloomDistribution = {
        "remember": 0,
        "understand": 0,
        "apply": 100,
        "analyze": 0,
        "evaluate": 0,
        "create": 0
      };

      // Build FormData with JSON string fields for distributions
      final formMap = <String, dynamic>{
        'board': boarduuid,
        'grade': gradeuuid,
        'subject': subjectuuid,
        'number_of_questions': numberOfQuestions.toString(),
        'question_distribution': jsonEncode(qd),
        'difficulty_level_distribution': jsonEncode(difficultyDistribution),
        'bloom_taxonomy_distribution': jsonEncode(bloomDistribution),
      };

      if (topic != null) formMap['topic'] = topic;
      if (section != null) formMap['section'] = section;

      String contentType = "multipart/form-data";
      String payloadBoundry = "----WebKitFormBoundary1212";
      String formBoundry = "----WebKitFormBoundary1212";

      final metaDresponse = await ApiService.cgfDio.post(
        "/worksheet/v1/metadata",
        options: Options(
          headers: {
            "Content-Type": "$contentType; boundary=$payloadBoundry",
          },
        ),
        data: FormData.fromMap(
          formMap,
          ListFormat.multi,
          false,
          formBoundry,
        ),
      );

      if ((metaDresponse.statusCode != 200 &&
          metaDresponse.statusCode != 201)) {
        throw AssessmentFailure(
          status: AssessmentGenStatus.metaDataPostFailure,
          failureMessage: 'Error Encountered in Meta Data Post',
        );
      }

      String assessmentID = metaDresponse.data?['detail']?[0]?['id'];
      if (assessmentID.isEmpty) {
        throw AssessmentFailure(
          status: AssessmentGenStatus.metaDataPostFailure,
          failureMessage: 'Invalid Assessment Id',
        );
      }

      pollData(
        endpoint: "/worksheet/v1/metadata/$assessmentID",
        onSuccess: (data) {
          // After metadata GET, automatically post question config
          emit(
            AssessmentGeneration(
              assessmentID: assessmentID,
              data: data,
              status: AssessmentGenStatus.metaDataGet,
            ),
          );
          // Automatically move to next step
          Future.delayed(Duration(milliseconds: 500), () {
            finalizeQuestionConfig(
              assessmentID: assessmentID,
              metaData: data,
            );
          });
        },
        onFailure: (error) {
          emit(
            AssessmentFailure(
              status: AssessmentGenStatus.metaDataGetFailure,
              failureMessage: '$error',
            ),
          );
        },
      );
    } catch (e) {
      log('$e');
      if (e is AssessmentState) {
        emit(e);
      } else {
        emit(
          AssessmentFailure(
            status: AssessmentGenStatus.internalFailure,
            failureMessage: '$e',
          ),
        );
      }
    }
  }

  /// Finalize metadata by posting subject_matter & learning_standards
  void finalizeQuestionConfig({
    required String assessmentID,
    required Map<String, dynamic> metaData,
  }) async {
    try {
      emit(AssessmentLoadingState(
          status: AssessmentGenStatus.finalizeDataPostLoading));

      final payload = {
        "subject_matter": metaData['subject_matter'],
        "learning_standards": metaData['learning_standards'],
      };

      final response = await ApiService.cgfDio.post(
        "/worksheet/v1/question-config/$assessmentID",
        data: payload,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw AssessmentFailure(
          status: AssessmentGenStatus.finalizeDataPostFailure,
          failureMessage: 'Error Encountered in Question Config Post',
        );
      }

      pollData(
        endpoint: "/worksheet/v1/question-config/$assessmentID",
        onSuccess: (data) {
          emit(
            AssessmentGeneration(
              assessmentID: assessmentID,
              data: data["question_configuration"],
              status: AssessmentGenStatus.finalizeDataGet,
            ),
          );
          // Automatically move to next step
          Future.delayed(Duration(milliseconds: 500), () {
            startGeneration(
              assessmentID: assessmentID,
              questionConfigData: data["question_configuration"],
            );
          });
        },
        onFailure: (error) {
          emit(
            AssessmentFailure(
              status: AssessmentGenStatus.finalizeDataGetFailure,
              failureMessage: '$error',
            ),
          );
        },
      );
    } catch (e) {
      log('$e');
      if (e is AssessmentState) {
        emit(e);
      } else {
        emit(AssessmentFailure(
            status: AssessmentGenStatus.internalFailure, failureMessage: '$e'));
      }
    }
  }

  /// Start generation by posting question summaries
  void startGeneration({
    required String assessmentID,
    required Map<String, dynamic> questionConfigData,
  }) async {
    try {
      emit(AssessmentLoadingState(
          status: AssessmentGenStatus.generationDataPostLoading));

      final payload = {
        "question_summary": questionConfigData['question_summary'],
        "bloom_summary": questionConfigData['bloom_summary'],
        "difficulty_summary": questionConfigData['difficulty_summary'],
        "question_type_summary": questionConfigData['question_type_summary'],
      };

      final response = await ApiService.cgfDio.post(
        "/worksheet/v1/generate-worksheet/$assessmentID",
        data: payload,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw AssessmentFailure(
          status: AssessmentGenStatus.generationDataPostFailure,
          failureMessage: 'Error Encountered in Generation Post',
        );
      }

      pollData(
        endpoint: "/worksheet/v1/generate-worksheet/$assessmentID",
        onSuccess: (data) {
          // Save to Hive when final generation is complete
          try {
            final historyModel = AssessmentHistoryModel(
              assessmentID: assessmentID,
              data: data,
              createdAt: DateTime.now(),
              boardName: _currentBoardName,
              gradeName: _currentGradeName,
              subjectName: _currentSubjectName,
              duration: _currentNumberOfQuestions,
              topics: _currentTopic,
            );
            HiveService.saveAssessment(historyModel);
          } catch (e) {
            log('Error saving assessment to history: $e');
          }

          emit(
            AssessmentGeneration(
              assessmentID: assessmentID,
              data: data,
              status: AssessmentGenStatus.generationDataGet,
            ),
          );
        },
        onFailure: (error) {
          emit(
            AssessmentFailure(
              status: AssessmentGenStatus.generationDataGetFailure,
              failureMessage: '$error',
            ),
          );
        },
      );
    } catch (e) {
      log('$e');
      if (e is AssessmentState) {
        emit(e);
      } else {
        emit(AssessmentFailure(
            status: AssessmentGenStatus.internalFailure, failureMessage: '$e'));
      }
    }
  }

  void pollData({
    required String endpoint,
    required Function(Map<String, dynamic> data) onSuccess,
    required Function(dynamic data) onFailure,
  }) async {
    try {
      pollingTimer?.cancel();
      pollingTimer = Timer.periodic(
        const Duration(seconds: 5),
        (timer) async {
          final response = await ApiService.cgfDio.get(endpoint);

          if (response.statusCode == 200) {
            final data = response.data['data'];
            final status = data['status']?.toString().toLowerCase();

            if (status == 'completed' || status == 'success') {
              timer.cancel();
              onSuccess(data);
            } else if (status == 'failed' || status == 'failure') {
              timer.cancel();
              onFailure(data);
            }
          } else {
            timer.cancel();
            onFailure(response.data);
          }
        },
      );
    } catch (e) {
      onFailure(e);
    }
  }

  /// Generate and download assessment HTML
  Future<void> generateAndDownloadHTML(
    Map<String, dynamic> assessmentData,
    String topic,
  ) async {
    try {
      final htmlContent = await AssessmentHtmlGenerator.generateAssessmentHtml(
        {'data': assessmentData},
      );
      await AssessmentHtmlGenerator.downloadHtml(htmlContent, topic);
    } catch (e) {
      log('Error generating/downloading HTML: $e');
      rethrow;
    }
  }
}
