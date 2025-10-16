import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:lessonplan/bloc/lessonplan/lesson_plan_cubit.dart';
import 'package:lessonplan/util/router/router.dart';

final sl = GetIt.instance;
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> init() async {
  sl.registerLazySingleton(() => AppRouter());

  // Cubits
  sl.registerLazySingleton(() => LessonPlanCubit());
}
