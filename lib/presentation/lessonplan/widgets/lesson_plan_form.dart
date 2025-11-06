import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lessonplan/bloc/lessonplan/lesson_plan_cubit.dart';
import 'package:lessonplan/models/form_data_models.dart';
import 'package:lessonplan/presentation/core/custom_button.dart';
import 'package:lessonplan/presentation/core/labeled_custom_field.dart';
import 'package:lessonplan/presentation/core/svg_widget.dart';
import 'package:lessonplan/presentation/lessonplan/functions.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/dialog/custom_timepicker_dialog.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/labeled_time_picker.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/lp_form_field.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/popups/generating_popup.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/popups/no_internet_popup.dart';
import 'package:lessonplan/services/connectivity/connectivity.service.dart';
import 'package:lessonplan/services/injection/getit.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

ValueNotifier<Board?> selectedBoard = ValueNotifier(null);
ValueNotifier<Grade?> selectedGrade = ValueNotifier(null);
ValueNotifier<LPDuration?> selectedDuration = ValueNotifier(null);
ValueNotifier<Subject?> selectedSubject = ValueNotifier(null);
ValueNotifier<String?> topic = ValueNotifier(null);
ValueNotifier<bool> isValidForm = ValueNotifier(false);
bool isErrorDialogMounted = false;

class LessonPlanForm extends StatefulWidget {
  const LessonPlanForm({super.key});

  @override
  State<LessonPlanForm> createState() => _LessonPlanFormState();
}

class _LessonPlanFormState extends State<LessonPlanForm> {
  bool internetFailure = true;
  List<Board> boards = [];
  List<Grade> grades = [];
  List<Subject> subjects = [];
  late TextEditingController topicController;

  @override
  void initState() {
    topicController = TextEditingController();
    topicController.addListener(() {
      isValidForm.value = isFormValid();
    });
    super.initState();
  }

  bool isFormValid() {
    try {
      if (selectedBoard.value == null ||
          selectedBoard.value!.name.replaceAll(" ", "").isEmpty ||
          selectedGrade.value == null ||
          selectedBoard.value!.name.replaceAll(" ", "").isEmpty ||
          selectedDuration.value == null ||
          selectedDuration.value!.minutes < 1 ||
          selectedSubject.value == null ||
          selectedSubject.value!.name.replaceAll(" ", "").isEmpty ||
          topicController.text.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LessonPlanCubit, LessonPlanState>(
        bloc: sl<LessonPlanCubit>()..authenticateUser(),
        listener: (context, state) {
          if (state is LessonPlanAuthState) {
            sl<LessonPlanCubit>().fetchBoards();
          }

          if (state is LessonPlanLoadingState) {
            if (state.status == LessonPlanStatus.metaDataPostLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return GeneratingLessonPlanPopup();
                },
              );
            }
          }
        },
        builder: (context, state) {
          if (state is LessonPlanAuthFailedState) {
            if (!isErrorDialogMounted) {
              isErrorDialogMounted = true;
              LessonPlanFunctions.showAuthError();
            }
          }

          if (state is LessonPlanAuthState) {
            if (isErrorDialogMounted) {
              isErrorDialogMounted = false;
              context.router.pop();
            }
          }

          if (state is LessonPlanBoardsState) {
            boards = state.boards;
          }

          if (state is LessonPlanGradesState) {
            grades = state.grades;
          }

          if (state is LessonPlanSubjectsState) {
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
                            return NoInternetPopup();
                          },
                        );
                      }
                    });
                    internetFailure = false;
                  }
                } else if (internetFailure == false) {
                  internetFailure = true;
                  context.maybePop();
                }

                return ValueListenableBuilder(
                    valueListenable: isValidForm,
                    builder: (context, value, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
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
                                    sl<LessonPlanCubit>()
                                        .fetchGrades(board: item);
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
                                    sl<LessonPlanCubit>().fetchSubjects(
                                      board: selectedBoard.value!,
                                      grade: item,
                                    );
                                    isValidForm.value = isFormValid();
                                  },
                                ),
                                LabeledTimePicker(
                                  label: "Duration",
                                  hintText: "00 Minutes",
                                  listenable: selectedDuration,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomTimePickerDialog();
                                      },
                                    ).then((time) {
                                      if (time is TimeOfDay) {
                                        selectedDuration.value = LPDuration(
                                          minutes:
                                              (time.hour * 60 + time.minute),
                                        );
                                        isValidForm.value = isFormValid();
                                      }
                                    });
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
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: LabeledCustomField(
                                    label: "Topic",
                                    isRequired: true,
                                    child: Material(
                                      textStyle:
                                          const TextStyle(fontFamily: 'Inter'),
                                      color: Colors.transparent,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        enabled: true,
                                        controller: topicController,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(16),
                                          counterText: "",
                                          hintText: "Enter Topic Name",
                                          hintStyle:
                                              TextStyles.textRegular16.copyWith(
                                            color: ColorConstants.grey,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: const BorderSide(
                                              color: ColorConstants.darkBlue,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                              color: ColorConstants.lightGrey,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: const BorderSide(
                                              color: ColorConstants.lightGrey,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor:
                                              ColorConstants.primaryWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 48),
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
                                  "Generate Lesson Plan",
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
                                try {
                                  sl<LessonPlanCubit>().generateLessonPlan(
                                    boarduuid: selectedBoard.value!.uuid,
                                    gradeuuid: selectedGrade.value!.uuid,
                                    durationInMinutes: selectedDuration
                                        .value!.minutes
                                        .toString(),
                                    subjectuuid: selectedSubject.value!.uuid,
                                    topics: topicController.text,
                                    boardName: selectedBoard.value!.name,
                                    gradeName: selectedGrade.value!.name,
                                    subjectName: selectedSubject.value!.name,
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("$e"),
                                    ),
                                  );
                                }
                              }
                            },
                          )
                        ],
                      );
                    });
              });
        });
  }
}
