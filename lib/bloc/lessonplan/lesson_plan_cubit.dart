import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lessonplan/config/config_reader.dart';
import 'package:lessonplan/models/form_data_models.dart';
import 'package:lessonplan/models/lesson_plan_history_model.dart';
import 'package:lessonplan/services/api/api.service.dart';
import 'package:lessonplan/services/hive_service.dart';
import 'package:lessonplan/util/constants/constants.dart';

part 'lesson_plan_state.dart';

class LessonPlanCubit extends Cubit<LessonPlanState> {
  LessonPlanCubit() : super(LessonPlanInitialState());

  Timer? pollingTimer;

  // Store metadata for saving history later
  String? _currentBoardName;
  String? _currentGradeName;
  String? _currentSubjectName;
  String? _currentDuration;
  String? _currentTopics;

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
      emit(LessonPlanAuthState());
    } catch (e) {
      log('$e');
      emit(LessonPlanAuthFailedState());
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

      emit(LessonPlanBoardsState(boards: boards));
    } catch (e) {
      log('$e');
      emit(LessonPlanBoardsFailedState());
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

      emit(LessonPlanGradesState(grades: grades));
    } catch (e) {
      log('$e');
      emit(LessonPlanGradesFailedState());
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

      emit(LessonPlanSubjectsState(subjects: subjects));
    } catch (e) {
      emit(LessonPlanSubjectsFailedState());
    }
  }

  void generateLessonPlan({
    required String boarduuid,
    required String gradeuuid,
    required String durationInMinutes,
    required String subjectuuid,
    required String topics,
    required String boardName,
    required String gradeName,
    required String subjectName,
  }) async {
    // Store metadata for later use when saving history
    _currentBoardName = boardName;
    _currentGradeName = gradeName;
    _currentSubjectName = subjectName;
    _currentDuration = durationInMinutes;
    _currentTopics = topics;

    try {
      // META DATA POST
      emit(
        LessonPlanLoadingState(
          status: LessonPlanStatus.metaDataPostLoading,
        ),
      );

      final topicsString = topics.split(',').map((e) => e.trim()).join(', ');

      final payload = {
        "board": boarduuid,
        "grade": gradeuuid,
        "subject": subjectuuid,
        "duration_minutes": durationInMinutes,
        "topic": topicsString,
      };

      String contentType = "multipart/form-data";
      String payloadBoundry = "----WebKitFormBoundary1212";
      String formBoundry = "----WebKitFormBoundary1212";

      final metaDresponse = await ApiService.cgfDio.post(
        "/lesson-plan/v1/metadata",
        options: Options(
          headers: {
            "Content-Type": "$contentType; boundary=$payloadBoundry",
          },
        ),
        data: FormData.fromMap(
          payload,
          ListFormat.multi,
          false,
          formBoundry,
        ),
      );

      if ((metaDresponse.statusCode != 200 &&
          metaDresponse.statusCode != 201)) {
        // TODO: Work on Error Messages
        throw LessonPlanFailure(
          status: LessonPlanStatus.metaDataPostFailure,
          failureMessage: 'Error Encountered in Meta Data Post',
        );
      }

      String lessonPlanID = metaDresponse.data?['detail']?[0]?['id'];
      if (lessonPlanID.isEmpty) {
        throw LessonPlanFailure(
          status: LessonPlanStatus.metaDataPostFailure,
          failureMessage: 'Invalid Lesson Plan Id',
        );
      }

      pollData(
        endpoint: "/lesson-plan/v1/metadata/$lessonPlanID",
        onSuccess: (data) {
          emit(
            LessonPlanGeneration(
              lessonPlanID: lessonPlanID,
              data: data,
              status: LessonPlanStatus.metaDataGet,
            ),
          );
        },
        onFailure: (error) {
          // TODO: Add Specific failed cases
          emit(
            LessonPlanFailure(
              status: LessonPlanStatus.metaDataGetFailure,
              failureMessage: '$error',
            ),
          );
        },
      );
    } catch (e) {
      log('$e');
      if (e is LessonPlanState) {
        emit(e);
      } else {
        emit(
          LessonPlanFailure(
            status: LessonPlanStatus.internalFailure,
            failureMessage: '$e',
          ),
        );
      }
    }
  }

  void finalizeMetaDataAndGenerate({
    required String lessonPlanID,
    required Map<String, dynamic> metaData,
  }) async {
    try {
      emit(
        LessonPlanLoadingState(
          status: LessonPlanStatus.finalizeDataPostLoading,
        ),
      );

      final payload = {
        "subject_matter": metaData['subject_matter'],
        "learning_standards": metaData['learning_standards'],
      };

      final alignmentDResponse = await ApiService.cgfDio.post(
        "/lesson-plan/v1/finalize-metadata/$lessonPlanID",
        data: payload,
      );

      if (alignmentDResponse.statusCode != 200 &&
          alignmentDResponse.statusCode != 201) {
        throw LessonPlanFailure(
          status: LessonPlanStatus.finalizeDataPostFailure,
          failureMessage: 'Error Encountered in Alignment Post',
        );
      }

      pollData(
        endpoint: "/lesson-plan/v1/finalize-metadata/$lessonPlanID",
        onSuccess: (data) {
          emit(
            LessonPlanGeneration(
              lessonPlanID: lessonPlanID,
              data: data,
              status: LessonPlanStatus.finalizeDataGet,
            ),
          );
        },
        onFailure: (error) {
          emit(
            LessonPlanFailure(
              status: LessonPlanStatus.finalizeDataGetFailure,
              failureMessage: '$error',
            ),
          );
        },
      );
    } catch (e) {
      log('$e');
      if (e is LessonPlanState) {
        emit(e);
      } else {
        emit(
          LessonPlanFailure(
            status: LessonPlanStatus.internalFailure,
            failureMessage: '$e',
          ),
        );
      }
    }
  }

  void startGeneration({
    required String lessonPlanID,
    required Map<String, dynamic> alignmentData,
  }) async {
    try {
      emit(
        LessonPlanLoadingState(
          status: LessonPlanStatus.finalizeDataPostLoading,
        ),
      );

      final payload = {"alignment": alignmentData['alignment']};

      final generationDResponse = await ApiService.cgfDio.post(
        "/lesson-plan/v1/instructional-framework-builder/$lessonPlanID",
        data: payload,
      );

      if (generationDResponse.statusCode != 200 &&
          generationDResponse.statusCode != 201) {
        throw LessonPlanFailure(
          status: LessonPlanStatus.finalizeDataPostFailure,
          failureMessage: 'Error Encountered in Generation Post',
        );
      }

      pollData(
        endpoint:
            "/lesson-plan/v1/instructional-framework-builder/$lessonPlanID",
        onSuccess: (data) {
          // Save to Hive for history - only save when final generation is complete
          // This ensures we have the complete content_generation data for PDF
          try {
            final historyModel = LessonPlanHistoryModel(
              lessonPlanID: lessonPlanID,
              data: data,
              createdAt: DateTime.now(),
              boardName: _currentBoardName,
              gradeName: _currentGradeName,
              subjectName: _currentSubjectName,
              duration: _currentDuration,
              topics: _currentTopics,
            );
            HiveService.saveLessonPlan(historyModel);
          } catch (e) {
            log('Error saving lesson plan to history: $e');
          }

          emit(
            LessonPlanGeneration(
              lessonPlanID: lessonPlanID,
              data: data,
              status: LessonPlanStatus.generationDataGet,
            ),
          );
        },
        onFailure: (error) {
          emit(
            LessonPlanFailure(
              status: LessonPlanStatus.generationDataGetFailure,
              failureMessage: '$error',
            ),
          );
        },
      );
    } catch (e) {
      log('$e');
      if (e is LessonPlanState) {
        emit(e);
      } else {
        emit(
          LessonPlanFailure(
            status: LessonPlanStatus.internalFailure,
            failureMessage: '$e',
          ),
        );
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
}
