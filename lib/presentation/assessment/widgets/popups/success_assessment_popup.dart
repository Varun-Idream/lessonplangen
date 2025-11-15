import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/custom_button.dart';
import 'package:lessonplan/presentation/core/fade_in_modal.dart';
import 'package:lessonplan/presentation/core/svg_widget.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class SuccessAssessmentPopup extends StatelessWidget {
  final VoidCallback assessmentHistory;
  final VoidCallback downloadHTML;
  const SuccessAssessmentPopup({
    super.key,
    required this.assessmentHistory,
    required this.downloadHTML,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInModal(
      maxWidth: 430,
      scrollable: false,
      child: Material(
        textStyle: TextStyle(
          fontFamily: "Inter",
          decoration: TextDecoration.none,
        ),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstants.tertiaryBgBlue,
              ),
              padding: const EdgeInsets.all(10),
              child: FittedBox(
                fit: BoxFit.fill,
                child: AssetSvg(Assets.partypop),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Assessment Generated Successfully",
              style: TextStyles.textMedium18.copyWith(
                fontWeight: FontWeight.w600,
                color: ColorConstants.primaryBlack,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Your AI-generated assessment has been successfully created All your generated \n Assessments are automatically saved in History for future access.",
              style: TextStyle(
                color: ColorConstants.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: CustomButton(
                    title: 'Assessment History',
                    backgroundColor: ColorConstants.primaryBlue.withAlpha(20),
                    textColor: ColorConstants.primaryBlue,
                    onTap: assessmentHistory,
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  fit: FlexFit.tight,
                  child: CustomButton(
                    title: 'Download HTML',
                    onTap: downloadHTML,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
