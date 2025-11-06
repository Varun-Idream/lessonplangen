import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lessonplan/bloc/lessonplan_history/lesson_plan_history_cubit.dart';
import 'package:lessonplan/models/lesson_plan_history_model.dart';
import 'package:lessonplan/services/injection/getit.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/history/history_table_cells.dart';

class HistoryTable extends StatelessWidget {
  final List<LessonPlanHistoryModel> history;
  final ScrollController scrollController;
  final Function(LessonPlanHistoryModel) onView;
  final Function(LessonPlanHistoryModel) onDownload;

  const HistoryTable({
    super.key,
    required this.history,
    required this.scrollController,
    required this.onView,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final availableWidth = screenWidth - 90;

        return Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: availableWidth),
              child: _TableContent(
                history: history,
                availableWidth: availableWidth,
                onView: onView,
                onDownload: onDownload,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TableContent extends StatelessWidget {
  final List<LessonPlanHistoryModel> history;
  final double availableWidth;
  final Function(LessonPlanHistoryModel) onView;
  final Function(LessonPlanHistoryModel) onDownload;

  const _TableContent({
    required this.history,
    required this.availableWidth,
    required this.onView,
    required this.onDownload,
  });

  static const _flexValues = {
    0: 1.0,
    1: 1.5,
    2: 1.2,
    3: 1.5,
    4: 2.5,
    5: 1.5,
    6: 1.6,
    7: 1.5,
  };

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        for (int i = 0; i < 8; i++) i: FlexColumnWidth(_flexValues[i]!),
      },
      children: [
        _buildHeaderRow(),
        ...history.asMap().entries.map((entry) => _buildDataRow(
              entry.value,
              entry.key + 1,
              entry.key < history.length - 1,
            )),
      ],
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: const BoxDecoration(
        color: ColorConstants.thinGrey2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      children: const [
        HistoryTableHeaderCell(text: 'S.No.', isSortable: false),
        HistoryTableHeaderCell(text: 'Created On', isSortable: true),
        HistoryTableHeaderCell(text: 'Class', isSortable: false),
        HistoryTableHeaderCell(text: 'Subject', isSortable: false),
        HistoryTableHeaderCell(text: 'Topic', isSortable: false),
        HistoryTableHeaderCell(text: 'Duration', isSortable: false),
        HistoryTableHeaderCell(text: 'Creator', isSortable: false),
        HistoryTableHeaderCell(text: 'Actions', isSortable: false),
      ],
    );
  }

  TableRow _buildDataRow(LessonPlanHistoryModel item, int serialNumber, bool hasBorder) {
    final cubit = sl<LessonPlanHistoryCubit>();
    final creator = cubit.getCreator(item);
    final dateFormat = DateFormat('dd-MM-yyyy');
    final formattedDate = dateFormat.format(item.createdAt);
    final topicsDisplay = _formatTopics(item.topics);

    return TableRow(
      decoration: BoxDecoration(
        color: ColorConstants.primaryWhite,
        border: hasBorder
            ? const Border(
                bottom: BorderSide(
                  color: ColorConstants.lightGrey2,
                  width: 1,
                ),
              )
            : null,
      ),
      children: [
        HistoryTableCell(text: serialNumber.toString()),
        HistoryTableCell(text: formattedDate),
        HistoryTableCell(text: item.gradeName ?? '-'),
        HistoryTableSubjectCell(text: item.subjectName ?? '-'),
        HistoryTableCell(text: topicsDisplay, maxLines: 2),
        HistoryTableCell(
          text: item.duration != null ? '${item.duration} Minutes' : '-',
        ),
        HistoryTableCell(text: creator ?? 'System'),
        HistoryTableActionsCell(
          item: item,
          onView: () => onView(item),
          onDownload: () => onDownload(item),
        ),
      ],
    );
  }

  String _formatTopics(String? topics) {
    if (topics == null || topics == '-') return '-';

    final topicsList = topics.split(',');
    if (topicsList.length > 1) {
      final firstTopic = topicsList[0].trim();
      final remainingCount = topicsList.length - 1;
      if (firstTopic.length > 30) {
        return '${firstTopic.substring(0, 30)}... +$remainingCount';
      }
      return '$firstTopic... +$remainingCount';
    }

    final topic = topicsList[0].trim();
    return topic.length > 30 ? '${topic.substring(0, 30)}...' : topic;
  }
}

