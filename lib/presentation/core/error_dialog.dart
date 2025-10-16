import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/fade_in_modal.dart';
import 'package:lessonplan/presentation/core/svg_widget.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String text;
  final Widget? actions;

  const ErrorDialog({
    super.key,
    this.title = "Some Error Occured",
    this.text = "",
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInModal(
      maxWidth: 400,
      backgroundColor: ColorConstants.primaryWhite,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 4),
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: ColorConstants.primaryRed.withAlpha(30),
              border: Border.all(
                width: 2,
                color: ColorConstants.primaryRed.withAlpha(50),
              ),
              shape: BoxShape.circle,
            ),
            child: FittedBox(
              fit: BoxFit.fill,
              child: AssetSvg(Assets.errorIcon),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyles.textRegular16.copyWith(
              color: ColorConstants.primaryBlack,
              height: 1.2,
              fontFamily: "Inter",
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          if (text.isNotEmpty)
            Text(
              text,
              style: TextStyles.textRegular18Greyh3,
            ),
          const SizedBox(height: 10),
          if (actions != null) actions ?? SizedBox(),
        ],
      ),
    );
  }
}
