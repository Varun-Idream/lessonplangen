import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/circular_icon_button.dart';
import 'package:lessonplan/presentation/core/custom_button.dart';
import 'package:lessonplan/presentation/core/fade_in_modal.dart';
import 'package:lessonplan/presentation/core/svg_widget.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class ExsistingPlanFoundPopup extends StatelessWidget {
  const ExsistingPlanFoundPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInModal(
      maxWidth: 450,
      scrollable: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircularIconButton(
                iconData: Icons.close,
                borderColor: ColorConstants.primaryBlue,
                backgroundColor: ColorConstants.tertiaryBgBlue,
                onTap: () {
                  context.maybePop();
                },
              ),
            ],
          ),
          Container(
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConstants.tertiaryBgBlue,
            ),
            padding: const EdgeInsets.all(15),
            child: FittedBox(
              fit: BoxFit.fill,
              child: AssetSvg(Assets.alreadyExsists),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Lesson Plan Already Exists",
            style: TextStyles.textMedium18.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "A lesson plan for this class, subject, and topic \n already exists, created by another teacher. \n You can download and review the existing plan, \n or create a new one if you wish to customize it.",
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
                  title: 'Create New Plan',
                  backgroundColor: ColorConstants.primaryBlue.withAlpha(20),
                  textColor: ColorConstants.primaryBlue,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                fit: FlexFit.tight,
                child: CustomButton(
                  title: 'Download Lesson Plan',
                  onTap: () {},
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
