import 'package:flutter/widgets.dart';

class LessonPlanHistory extends StatefulWidget {
  const LessonPlanHistory({super.key});

  @override
  State<LessonPlanHistory> createState() => _LessonPlanHistoryState();
}

class _LessonPlanHistoryState extends State<LessonPlanHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("Lesson Plan History"),
    );
  }
}
