import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lessonplan/bloc/assessment/assessment_cubit.dart';
import 'package:lessonplan/presentation/assessment/assessment_functions.dart';
import 'package:lessonplan/presentation/assessment/assessment_plan_screen.dart';
import 'package:lessonplan/presentation/core/fade_in_modal.dart';
import 'package:lessonplan/presentation/assessment/widgets/popups/success_assessment_popup.dart';
import 'package:lessonplan/services/injection/getit.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';
import 'package:lessonplan/util/router/router.dart';

ValueNotifier<double> assessmentGenerationState = ValueNotifier(0.0);

class GeneratingAssessmentPopup extends StatelessWidget {
  const GeneratingAssessmentPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInModal(
      maxWidth: 430,
      scrollable: false,
      child: BlocConsumer<AssessmentCubit, AssessmentState>(
        bloc: sl<AssessmentCubit>(),
        listener: (context, state) {
          if (state is AssessmentLoadingState) {
            switch (state.status) {
              case AssessmentGenStatus.metaDataGetLoading:
                assessmentGenerationState.value = 0.0;
              case AssessmentGenStatus.finalizeDataGetLoading:
                assessmentGenerationState.value = 0.6;
              case AssessmentGenStatus.generationDataGetLoading:
                assessmentGenerationState.value = 0.8;
              default:
                break;
            }
          }

          if (state is AssessmentGeneration) {
            switch (state.status) {
              case AssessmentGenStatus.metaDataGet:
                assessmentGenerationState.value = 0.25;
                // Move to next step
                break;
              case AssessmentGenStatus.finalizeDataGet:
                assessmentGenerationState.value = 0.5;
                // Move to next step
                break;
              case AssessmentGenStatus.generationDataGet:
                assessmentGenerationState.value = 1.0;
                context.router.pop();
                assessmentGenerationState.value = 0.0;

                AssessmentHtmlGenerator.generateAssessmentHtml(state.data)
                    .then((htmlString) {
                  if (sl<AppRouter>().navigatorKey.currentContext != null) {
                    showDialog(
                      context: sl<AppRouter>().navigatorKey.currentContext!,
                      builder: (context) {
                        return SuccessAssessmentPopup(
                          assessmentHistory: () {
                            context.router.pop();
                            selectedTab.value = 0;
                          },
                          downloadHTML: () {
                            AssessmentHtmlGenerator.downloadHtml(
                              htmlString,
                              "Assessment",
                            );
                          },
                        );
                      },
                    );
                  }
                }).catchError((e) {
                  if (context.mounted) {
                    // Error handled silently, no snackbar
                  }
                });

                break;
              default:
                break;
            }
          }

          if (state is AssessmentFailure) {
            assessmentGenerationState.value = 0;
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
                    valueListenable: assessmentGenerationState,
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
                "Generating Your Assessment",
                style: TextStyles.textMedium18.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "We're preparing a customized assessment \n based on your selections. This may take a \n few seconds.",
                style: TextStyle(
                  color: ColorConstants.grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}
