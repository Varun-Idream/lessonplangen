import 'package:auto_route/auto_route.dart';
import 'package:lessonplan/presentation/dahsboard/dashboard.dart';
import 'package:lessonplan/presentation/lessonplan/lesson_plan_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});

  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: DashboardRoute.page,
          path: "/",
          initial: true,
        ),
        AutoRoute(
          page: LessonPlanRoute.page,
          path: "/lessonplan",
        ),
      ];

  // Route Guard
  @override
  List<AutoRouteGuard> get guards => [];
}
