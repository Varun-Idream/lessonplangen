import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/svg_widget.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

class AssessmentBanner extends StatelessWidget {
  const AssessmentBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: size.width * 9,
      constraints: BoxConstraints(maxWidth: 880, maxHeight: 155),
      padding: const EdgeInsets.only(
        left: 30,
        right: 10,
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: ColorConstants.bannerGradient,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.primaryBlack,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'Easily create structured Assessment aligned with\n',
                    ),
                    WidgetSpan(
                      child: SizedBox(width: 6),
                    ),
                    TextSpan(
                      text: 'NCERT guidelines',
                      style: TextStyle(
                        color: ColorConstants.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.primaryBlack,
                  ),
                  children: [
                    TextSpan(
                      text: 'You can generate up to',
                    ),
                    WidgetSpan(
                      child: SizedBox(width: 6),
                    ),
                    TextSpan(
                      text: '50 assessments/Month',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    WidgetSpan(
                      child: SizedBox(width: 6),
                    ),
                    TextSpan(
                      text: 'with your current access',
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 50),
          FittedBox(
            fit: BoxFit.fitHeight,
            child: AssetSvg(
              Assets.bannerIllustration,
            ),
          ),
        ],
      ),
    );
  }
}
