import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/custom_header.dart';
import 'package:lessonplan/presentation/core/custom_toggle.dart';
import 'package:lessonplan/presentation/lessonplan/lesson_plan_builder.dart';
import 'package:lessonplan/presentation/lessonplan/lesson_plan_history.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

ValueNotifier<int> selectedTab = ValueNotifier(1);

@RoutePage()
class LessonPlanScreen extends StatefulWidget {
  const LessonPlanScreen({super.key});

  @override
  State<LessonPlanScreen> createState() => _LessonPlanScreenState();
}

class _LessonPlanScreenState extends State<LessonPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryWhite,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(
              title: 'AI Lesson Plan',
              headerPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 25,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: selectedTab,
                      builder: (context, value, child) {
                        return CustomToggle(
                          selectedIndex: value,
                          labelPadding:
                              EdgeInsetsGeometry.symmetric(horizontal: 10),
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.primaryBlue,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          toggleTabs: [
                            ToggleTabs(label: 'Lesson Plan History'),
                            ToggleTabs(label: 'Lesson Plan Builder'),
                          ],
                          onChanged: (index) {
                            selectedTab.value = index;
                          },
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: selectedTab,
                      builder: (context, value, child) {
                        switch (value) {
                          case 0:
                            return LessonPlanHistory();
                          case 1:
                            return LessonPlanBuilder();
                          default:
                            return SizedBox();
                        }
                      },
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
