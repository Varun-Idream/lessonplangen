import 'package:flutter/material.dart';
import 'package:lessonplan/bloc/lessonplan/lesson_plan_cubit.dart';
import 'package:lessonplan/presentation/core/custom_button.dart';
import 'package:lessonplan/presentation/core/error_dialog.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/lesson_plan_form.dart';
import 'package:lessonplan/services/injection/getit.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/router/router.dart';

class LessonPlanFunctions {
  static void showAuthError() {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      final ctx = sl<AppRouter>().navigatorKey.currentContext;
      if (ctx == null) {
        return;
      }

      showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (context) {
          return ErrorDialog(
            title:
                "Error Occured While Authentication \n Kindly retry after some time \n or hit the retry button below",
            actions: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  backgroundColor: ColorConstants.lightGrey,
                  textColor: ColorConstants.grey,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  onTap: () {
                    sl<AppRouter>().pop();
                    sl<AppRouter>().pop();
                  },
                  title: "Dismiss",
                ),
                const SizedBox(width: 10),
                CustomButton(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  onTap: () {
                    sl<LessonPlanCubit>().authenticateUser();
                  },
                  title: "Retry",
                ),
              ],
            ),
          );
        },
      ).then((r) {
        isErrorDialogMounted = false;
      });
    });
  }
}
