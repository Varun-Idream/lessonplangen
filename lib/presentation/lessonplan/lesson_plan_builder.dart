import 'package:flutter/widgets.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/lesson_plan_banner.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/lesson_plan_form.dart';

class LessonPlanBuilder extends StatefulWidget {
  const LessonPlanBuilder({super.key});

  @override
  State<LessonPlanBuilder> createState() => _LessonPlanBuilderState();
}

class _LessonPlanBuilderState extends State<LessonPlanBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LessonPlanBanner(),
          const SizedBox(height: 36),
          LessonPlanForm(),
        ],
      ),
    );
  }
}
