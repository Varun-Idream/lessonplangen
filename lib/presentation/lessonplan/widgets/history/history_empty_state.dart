import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/svg_widget.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.primaryWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AssetSvg(
                'assets/images/svgs/not_found.svg',
                width: 259,
                height: 234,
              ),
              const SizedBox(height: 32),
              Text(
                'No Lesson Plan Found',
                style: TextStyles.textSemiBold16.copyWith(
                  color: ColorConstants.primaryBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'It looks like for the class/grade and subject you selected, no lesson plan is available.\nPlease create a new lesson plan or change filter',
                style: TextStyles.textRegular16.copyWith(
                  color: ColorConstants.mediumGrey3,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
