import 'package:flutter/material.dart';
import 'package:lessonplan/models/lesson_plan_history_model.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class HistoryTableCell extends StatelessWidget {
  final String text;
  final int maxLines;

  const HistoryTableCell({
    super.key,
    required this.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        text,
        style: TextStyles.textRegular14.copyWith(
          color: ColorConstants.primaryBlack,
          fontFamily: "Inter",
          fontSize: 14,
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }
}

class HistoryTableSubjectCell extends StatelessWidget {
  final String text;

  const HistoryTableSubjectCell({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (text.toLowerCase() == 'science')
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: ColorConstants.primaryRed,
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.only(right: 8),
            ),
          Flexible(
            child: Text(
              text,
              style: TextStyles.textRegular14.copyWith(
                color: ColorConstants.primaryBlack,
                fontFamily: "Inter",
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryTableHeaderCell extends StatelessWidget {
  final String text;
  final bool isSortable;

  const HistoryTableHeaderCell({
    super.key,
    required this.text,
    this.isSortable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: TextStyles.textSemiBold16.copyWith(
                color: ColorConstants.primaryBlack,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
              softWrap: false,
              overflow: TextOverflow.visible,
            ),
          ),
          if (isSortable) ...[
            const SizedBox(width: 6),
            const Icon(
              Icons.unfold_more,
              size: 18,
              color: ColorConstants.mediumGrey3,
            ),
          ],
        ],
      ),
    );
  }
}

class HistoryTableActionsCell extends StatelessWidget {
  final LessonPlanHistoryModel item;
  final VoidCallback onView;
  final VoidCallback onDownload;

  const HistoryTableActionsCell({
    super.key,
    required this.item,
    required this.onView,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: onView,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.visibility,
                color: ColorConstants.primaryBlue,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onDownload,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.download,
                color: ColorConstants.naturalGreen,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

