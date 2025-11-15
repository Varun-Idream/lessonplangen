import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/assessment/widgets/assessment_banner.dart';
import 'package:lessonplan/presentation/assessment/widgets/assessment_form.dart';

class AssessmentAIBuilder extends StatelessWidget {
  const AssessmentAIBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AssessmentBanner(),
          const SizedBox(height: 25),
          AssessmentForm(),
        ],
      ),
    );
  }
}
