import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/assessment/assessment_history.dart';
import 'package:lessonplan/presentation/core/custom_header.dart';
import 'package:lessonplan/presentation/core/custom_toggle.dart';
import 'package:lessonplan/presentation/assessment/assessment_ai_builder.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

ValueNotifier<int> selectedTab = ValueNotifier(1);

@RoutePage()
class AssessmentAIScreen extends StatefulWidget {
  const AssessmentAIScreen({super.key});

  @override
  State<AssessmentAIScreen> createState() => _AssessmentAIScreenState();
}

class _AssessmentAIScreenState extends State<AssessmentAIScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryWhite,
      body: Column(
        children: [
          CommonHeader(
            title: 'AI Assessment',
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
                        labelSize: Size(250, 45),
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        toggleTabs: [
                          ToggleTabs(label: 'AI Assessment History'),
                          ToggleTabs(label: 'Create AI Assessment'),
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
                          return AssessmentHistory();
                        case 1:
                          return AssessmentAIBuilder();
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
    );
  }
}
