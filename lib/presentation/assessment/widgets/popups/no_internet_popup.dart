import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/custom_button.dart';
import 'package:lessonplan/presentation/core/fade_in_modal.dart';
import 'package:lessonplan/presentation/core/svg_widget.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class AssessmentNoInternetPopup extends StatelessWidget {
  const AssessmentNoInternetPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInModal(
      maxWidth: 430,
      scrollable: false,
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
              child: AssetSvg(Assets.internetWarn),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "No Internet Connection",
            style: TextStyles.textMedium18.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "You're offline right now.\n Please check your network settings and try again",
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
                  title: 'Retry',
                  backgroundColor: ColorConstants.primaryBlue.withAlpha(20),
                  textColor: ColorConstants.primaryBlue,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                fit: FlexFit.tight,
                child: CustomButton(
                  title: 'Go to Settings',
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
