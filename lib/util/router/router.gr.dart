// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [DashboardScreen]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardScreen();
    },
  );
}

/// generated route for
/// [LessonPlanScreen]
class LessonPlanRoute extends PageRouteInfo<void> {
  const LessonPlanRoute({List<PageRouteInfo>? children})
      : super(LessonPlanRoute.name, initialChildren: children);

  static const String name = 'LessonPlanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LessonPlanScreen();
    },
  );
}

/// generated route for
/// [PdfExportPage]
class PdfExportRoute extends PageRouteInfo<void> {
  const PdfExportRoute({List<PageRouteInfo>? children})
      : super(PdfExportRoute.name, initialChildren: children);

  static const String name = 'PdfExportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PdfExportPage();
    },
  );
}
