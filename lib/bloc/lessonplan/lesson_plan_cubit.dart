import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lessonplan/config/config_reader.dart';
import 'package:lessonplan/models/form_data_models.dart';
import 'package:lessonplan/services/api/api.service.dart';
import 'package:lessonplan/util/constants/constants.dart';

part 'lesson_plan_state.dart';

class LessonPlanCubit extends Cubit<LessonPlanState> {
  LessonPlanCubit() : super(LessonPlanInitialState());

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
  }) async {
    try {
      // META DATA POST
      emit(LessonPlanGenerationState(status: LessonPlanStatus.metaDataPost));
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

      if ((metaDresponse.statusCode == 200 ||
          metaDresponse.statusCode == 201)) {
        throw LessonPlanGenerationFailedState(
          status: LessonPlanStatus.metaDataPost,
        );
      }
    } catch (e) {
      log('$e');
      if (e is LessonPlanState) {
        emit(e);
      } else {
        LessonPlanGenerationFailedState(status: LessonPlanStatus.failed);
      }
      // emit(e);
    }
  }
}
