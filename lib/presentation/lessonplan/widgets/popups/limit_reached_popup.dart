import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/custom_button.dart';
import 'package:lessonplan/presentation/core/fade_in_modal.dart';
import 'package:lessonplan/presentation/core/svg_widget.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class LimitReachedPopup extends StatelessWidget {
  const LimitReachedPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInModal(
      maxWidth: 450,
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
              child: AssetSvg(Assets.warningLimit),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Lesson Plan Limit Reached",
            style: TextStyles.textMedium18.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: ColorConstants.grey,
                fontSize: 14,
                fontFamily: "Inter",
              ),
              children: [
                TextSpan(
                  text: "You’ve reached the maximum of",
                ),
                WidgetSpan(child: SizedBox(width: 4)),
                TextSpan(
                  text: "20 lesson plans in a month \n",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                WidgetSpan(child: SizedBox(width: 4)),
                TextSpan(
                  text:
                      "for this License. You can still review your saved lesson plans in History or explore what other teachers have created and use them in your classroom.",
                )
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorConstants.lightGrey,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: AssetSvg(Assets.phone),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Call Us:",
                  style: TextStyles.textSemiBold16Grey,
                ),
                const SizedBox(width: 30),
                Text(
                  "18008899710",
                  style: TextStyles.textSemiBold16Grey.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorConstants.lightGrey,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: AssetSvg(Assets.email),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Email Us:",
                  style: TextStyles.textSemiBold16Grey,
                ),
                const SizedBox(width: 30),
                Text(
                  "support@idreameducation.org",
                  style: TextStyles.textSemiBold16Grey.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: CustomButton(
                  title: 'Close',
                  backgroundColor: ColorConstants.primaryBlue.withAlpha(20),
                  textColor: ColorConstants.primaryBlue,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: CustomButton(
                  title: 'View Lesson Plan History',
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
