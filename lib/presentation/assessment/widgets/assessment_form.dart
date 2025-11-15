import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lessonplan/bloc/assessment/assessment_cubit.dart';
import 'package:lessonplan/models/form_data_models.dart';
import 'package:lessonplan/presentation/assessment/globals.dart';
import 'package:lessonplan/presentation/assessment/widgets/labeled_counter.dart';
import 'package:lessonplan/presentation/core/custom_button.dart';
import 'package:lessonplan/presentation/core/labeled_custom_field.dart';
import 'package:lessonplan/presentation/core/svg_widget.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/lp_form_field.dart';
import 'package:lessonplan/presentation/assessment/widgets/popups/no_internet_popup.dart';
import 'package:lessonplan/presentation/assessment/widgets/popups/generating_assessment_popup.dart';
import 'package:lessonplan/services/connectivity/connectivity.service.dart';
import 'package:lessonplan/services/injection/getit.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class AssessmentForm extends StatefulWidget {
  const AssessmentForm({super.key});

  @override
  State<AssessmentForm> createState() => _AssessmentFormState();
}

class _AssessmentFormState extends State<AssessmentForm> {
  bool internetFailure = true;
  List<Board> boards = [];
  List<Grade> grades = [];
  List<Subject> subjects = [];
  late TextEditingController numberOfQuestionsController;
  late TextEditingController topicController;

  @override
  void initState() {
    numberOfQuestionsController = TextEditingController();
    topicController = TextEditingController();

    numberOfQuestionsController.addListener(() {
      isValidForm.value = isFormValid();
    });
    topicController.addListener(() {
      isValidForm.value = isFormValid();
    });

    mcqsingle.addListener(isFormValid);
    mcqmultiple.addListener(isFormValid);
    truefalse.addListener(isFormValid);
    fillintheblanks.addListener(isFormValid);
    matchthecolumns.addListener(isFormValid);
    veryshortans.addListener(isFormValid);
    super.initState();
  }

  bool isFormValid() {
    try {
      if (selectedBoard.value == null ||
          selectedBoard.value!.name.replaceAll(" ", "").isEmpty ||
          selectedGrade.value == null ||
          selectedGrade.value!.name.replaceAll(" ", "").isEmpty ||
          selectedSubject.value == null ||
          selectedSubject.value!.name.replaceAll(" ", "").isEmpty ||
          numberOfQuestionsController.text.isEmpty ||
          topicController.text.isEmpty) {
        return false;
      }

      if ((int.tryParse(numberOfQuestionsController.text) ?? 0) > 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Total Number of Questions cannot exceed 10"),
          ),
        );
        return false;
      }

      if (mcqsingle.value +
              mcqmultiple.value +
              truefalse.value +
              fillintheblanks.value +
              matchthecolumns.value +
              veryshortans.value >
          10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Total Number of Questions cannot exceed 10"),
          ),
        );
        return false;
      }

      final numQuestions = int.tryParse(numberOfQuestionsController.text) ?? 0;
      if (numQuestions < 1) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssessmentCubit, AssessmentState>(
      bloc: sl<AssessmentCubit>()..authenticateUser(),
      listener: (context, state) {
        if (state is AssessmentAuthState) {
          sl<AssessmentCubit>().fetchBoards();
        }

        if (state is AssessmentLoadingState) {
          if (state.status == LessonPlanStatus.metaDataPostLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return GeneratingAssessmentPopup();
              },
            );
          }
        }

        if (state is AssessmentAuthFailedState) {
          if (!isErrorDialogMounted) {
            isErrorDialogMounted = true;
            // Show error dialog if needed
          }
        }

        if (state is AssessmentAuthState) {
          if (isErrorDialogMounted) {
            isErrorDialogMounted = false;
            Navigator.of(context).maybePop();
          }
        }
      },
      builder: (context, state) {
        if (state is AssessmentBoardsState) {
          boards = state.boards;
        }

        if (state is AssessmentGradesState) {
          grades = state.grades;
        }

        if (state is AssessmentSubjectsState) {
          subjects = state.subjects;
        }

        return StreamBuilder<bool>(
          stream: NetworkInfo.isConnected(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == false) {
              if (internetFailure == true) {
                Future.delayed(Duration.zero, () {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AssessmentNoInternetPopup();
                      },
                    );
                  }
                });
                internetFailure = false;
              }
            } else if (internetFailure == false) {
              internetFailure = true;
              if (context.mounted) Navigator.of(context).maybePop();
            }

            return ValueListenableBuilder(
              valueListenable: isValidForm,
              builder: (context, value, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 825),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorConstants.lightGrey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 30,
                      ),
                      child: Wrap(
                        runAlignment: WrapAlignment.center,
                        runSpacing: 28,
                        spacing: 24,
                        alignment: WrapAlignment.center,
                        children: [
                          LPFormDropDown<Board>(
                            listenable: selectedBoard,
                            label: "Board",
                            items: boards,
                            hintText: "Select Board",
                            onChange: (item) {
                              selectedBoard.value = item;
                              sl<AssessmentCubit>().fetchGrades(board: item);
                              isValidForm.value = isFormValid();
                            },
                          ),
                          LPFormDropDown<Grade>(
                            listenable: selectedGrade,
                            label: "Grade",
                            items: grades,
                            hintText: "Select Grade",
                            onChange: (item) {
                              selectedGrade.value = item;
                              sl<AssessmentCubit>().fetchSubjects(
                                board: selectedBoard.value!,
                                grade: item,
                              );
                              isValidForm.value = isFormValid();
                            },
                          ),
                          LPFormDropDown<Subject>(
                            listenable: selectedSubject,
                            label: "Subject",
                            items: subjects,
                            hintText: "Select Subject",
                            onChange: (item) {
                              selectedSubject.value = item;
                              isValidForm.value = isFormValid();
                            },
                          ),
                          // Topic Section
                          Container(
                            width: 355,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: LabeledCustomField(
                              label: "Topic",
                              isRequired: true,
                              child: Material(
                                textStyle: const TextStyle(fontFamily: 'Inter'),
                                color: Colors.transparent,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  enabled: true,
                                  controller: topicController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText: "Enter topic or chapter name",
                                    hintStyle:
                                        TextStyles.textRegular16.copyWith(
                                      color: ColorConstants.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: const BorderSide(
                                        color: ColorConstants.darkBlue,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: ColorConstants.lightGrey,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: ColorConstants.primaryWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: LabeledCustomField(
                              label: "Number of Questions",
                              isRequired: true,
                              child: Material(
                                textStyle: const TextStyle(fontFamily: 'Inter'),
                                color: Colors.transparent,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  enabled: true,
                                  controller: numberOfQuestionsController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(16),
                                    counterText: "",
                                    hintText: "Enter number",
                                    hintStyle:
                                        TextStyles.textRegular16.copyWith(
                                      color: ColorConstants.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: const BorderSide(
                                        color: ColorConstants.darkBlue,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: ColorConstants.lightGrey,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: const BorderSide(
                                        color: ColorConstants.lightGrey,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: ColorConstants.primaryWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Question Type Distribution",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.primaryBlack,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 825,
                        minWidth: 825,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorConstants.lightGrey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 30,
                      ),
                      child: Wrap(
                        runSpacing: 30,
                        spacing: 20,
                        children: [
                          LabeledCounter(
                            notifier: mcqsingle,
                            label: "Multiple Choice Questions (Single)",
                          ),
                          LabeledCounter(
                            notifier: mcqmultiple,
                            label: "Multiple Choice Questions (Multiple)",
                          ),
                          LabeledCounter(
                            notifier: truefalse,
                            label: "True/False",
                          ),
                          LabeledCounter(
                            notifier: fillintheblanks,
                            label: "Fill in the Blanks",
                          ),
                          LabeledCounter(
                            notifier: matchthecolumns,
                            label: "Match the Columns",
                          ),
                          LabeledCounter(
                            notifier: veryshortans,
                            label: "Very Short Answers",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      backgroundColor: isValidForm.value
                          ? ColorConstants.primaryBlue
                          : ColorConstants.lightGrey,
                      width: 830,
                      titleWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          isValidForm.value
                              ? SizedBox(
                                  height: 24,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: AssetSvg(Assets.whitestars),
                                  ),
                                )
                              : SizedBox(
                                  height: 24,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: AssetSvg(Assets.blackstars),
                                  ),
                                ),
                          const SizedBox(width: 24),
                          Text(
                            "Generate Assessment",
                            style: isValidForm.value
                                ? TextStyles.textSemiBold16.copyWith(
                                    color: ColorConstants.primaryWhite,
                                  )
                                : TextStyles.textSemiBold16Grey,
                          )
                        ],
                      ),
                      onTap: () {
                        if (isValidForm.value) {
                          final numQuestions =
                              int.parse(numberOfQuestionsController.text);
                          sl<AssessmentCubit>().generateAssessment(
                            boarduuid: selectedBoard.value!.uuid,
                            gradeuuid: selectedGrade.value!.uuid,
                            subjectuuid: selectedSubject.value!.uuid,
                            numberOfQuestions: numQuestions,
                            topic: topicController.text,
                            boardName: selectedBoard.value!.name,
                            gradeName: selectedGrade.value!.name,
                            subjectName: selectedSubject.value!.name,
                          );
                        }
                      },
                    )
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    numberOfQuestionsController.dispose();
    topicController.dispose();

    mcqsingle.value = 0;
    mcqmultiple.value = 0;
    truefalse.value = 0;
    fillintheblanks.value = 0;
    matchthecolumns.value = 0;
    veryshortans.value = 0;

    mcqmultiple.removeListener(isFormValid);
    mcqmultiple.removeListener(isFormValid);
    truefalse.removeListener(isFormValid);
    fillintheblanks.removeListener(isFormValid);
    matchthecolumns.removeListener(isFormValid);
    veryshortans.removeListener(isFormValid);
    super.dispose();
  }
}
