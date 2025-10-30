import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lessonplan/bloc/lessonplan/lesson_plan_cubit.dart';
import 'package:lessonplan/presentation/core/fade_in_modal.dart';
import 'package:lessonplan/presentation/lessonplan/functions.dart';
import 'package:lessonplan/services/injection/getit.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

import 'success_created_popup.dart';

ValueNotifier<double> generationState = ValueNotifier(0.0);

class GeneratingLessonPlanPopup extends StatelessWidget {
  const GeneratingLessonPlanPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInModal(
      maxWidth: 430,
      scrollable: false,
      child: BlocConsumer<LessonPlanCubit, LessonPlanState>(
          bloc: sl<LessonPlanCubit>(),
          listener: (context, state) {
            if (state is LessonPlanGeneration) {
              switch (state.status) {
                case LessonPlanStatus.metaDataGet:
                  generationState.value = 0.25;
                  sl<LessonPlanCubit>().finalizeMetaDataAndGenerate(
                    lessonPlanID: state.lessonPlanID,
                    metaData: state.data,
                  );
                  break;
                case LessonPlanStatus.finalizeDataGet:
                  generationState.value = 0.5;
                  sl<LessonPlanCubit>().startGeneration(
                    lessonPlanID: state.lessonPlanID,
                    alignmentData: state.data,
                  );
                  break;
                case LessonPlanStatus.generationDataGet:
                  generationState.value = 1.0;
                  context.router.pop();

                  LessonPlanFunctions.processPDF(
                    generatedData: state.data,
                  );

                  showDialog(
                    context: context,
                    builder: (context) {
                      return SuccessCreatedPopup();
                    },
                  );
                  break;
                default:
                  break;
              }
            }

            if (state is LessonPlanLoadingState) {
              switch (state.status) {
                case LessonPlanStatus.metaDataGetLoading:
                  generationState.value = 0.0;
                case LessonPlanStatus.finalizeDataGetLoading:
                  generationState.value = 0.6;
                case LessonPlanStatus.generationDataGetLoading:
                  generationState.value = 0.8;
                default:
                  break;
              }
            }

            if (state is LessonPlanFailure) {
              generationState.value = 0;
              context.router.pop();
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                    ),
                    Positioned(
                      height: 104,
                      width: 104,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorConstants.tertiaryBgBlue,
                          shape: BoxShape.circle,
                        ),
                        child: CircularProgressIndicator(
                          color: ColorConstants.primaryBlue,
                          strokeWidth: 4,
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: generationState,
                      builder: (context, value, child) {
                        return AnimatedPositioned(
                          duration: Duration(milliseconds: 500),
                          height: value * 100,
                          width: value * 100,
                          curve: Curves.easeInCirc,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.lightGreen,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Image.asset(
                          Assets.aigif,
                        ),
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
          }),
    );
  }
}
