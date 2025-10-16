import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lessonplan/bloc/lessonplan/lesson_plan_cubit.dart';
import 'package:lessonplan/presentation/core/fade_in_modal.dart';
import 'package:lessonplan/services/injection/getit.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class GeneratingLessonPlanPopup extends StatelessWidget {
  const GeneratingLessonPlanPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInModal(
      maxWidth: 430,
      scrollable: false,
      child: BlocBuilder<LessonPlanCubit, LessonPlanState>(
        bloc: sl<LessonPlanCubit>(),
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.tertiaryBgBlue,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Image.asset(
                        Assets.aigif,
                      ),
                    ),
                  ),
                  Positioned(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      color: ColorConstants.primaryBlue,
                      strokeWidth: 4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                "Generating Your Lesson Plan",
                style: TextStyles.textMedium18.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "We’re preparing a customized plan based on \n your selections. This may take a few \n seconds.",
                style: TextStyle(
                  color: ColorConstants.grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }
      ),
    );
  }
}
