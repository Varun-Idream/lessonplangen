import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lessonplan/bloc/assessment_history/assessment_history_cubit.dart';
import 'package:lessonplan/models/assessment_history_model.dart';
import 'package:lessonplan/services/injection/getit.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/history/history_filter_bar.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/history/history_table.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/history/history_empty_state.dart';
import 'package:lessonplan/presentation/assessment/history_pdf_handler.dart';

class AssessmentHistory extends StatefulWidget {
  const AssessmentHistory({super.key});

  @override
  State<AssessmentHistory> createState() => _AssessmentHistoryState();
}

class _AssessmentHistoryState extends State<AssessmentHistory> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  Timer? _debounceTimer;
  String? _selectedClass;
  String? _selectedSubject;
  List<String> _availableClasses = ['All Class'];
  List<String> _availableSubjects = ['All Subject'];
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<AssessmentHistoryCubit>().loadHistory();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _applyFilters();
    });
  }

  void _applyFilters() {
    if (!mounted) return;
    sl<AssessmentHistoryCubit>().applyFilters(
      gradeName: _selectedClass,
      subjectName: _selectedSubject,
      searchQuery: _searchController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AssessmentHistoryCubit>(),
      child: BlocConsumer<AssessmentHistoryCubit, AssessmentHistoryState>(
        listener: _handleStateChanges,
        builder: _buildContent,
      ),
    );
  }

  void _handleStateChanges(BuildContext context, AssessmentHistoryState state) {
    if (state is AssessmentHistoryLoadedState) {
      final cubit = context.read<AssessmentHistoryCubit>();
      if (mounted) {
        final uniqueGrades = cubit.getUniqueGrades();
        final uniqueSubjects = cubit.getUniqueSubjects();

        setState(() {
          _availableClasses = ['All Class', ...uniqueGrades];
          _availableSubjects = ['All Subject', ...uniqueSubjects];
          if (_isInitialLoad) {
            _isInitialLoad = false;
          }
        });
      }
    }
  }

  Widget _buildContent(BuildContext context, AssessmentHistoryState state) {
    if (state is AssessmentHistoryLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AssessmentHistoryErrorState) {
      return Center(
        child: Text(
          state.errorMessage,
          style: TextStyles.textRegular16.copyWith(
            color: ColorConstants.primaryRed,
          ),
        ),
      );
    }

    if (state is AssessmentHistoryLoadedState) {
      return _buildHistoryContent(state.history);
    }

    return const SizedBox.shrink();
  }

  Widget _buildHistoryContent(List<AssessmentHistoryModel> history) {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - 200;

    // Adapt AssessmentHistoryModel to LessonPlanHistoryModel for HistoryTable reuse
    final adaptedHistory = history
        .map((a) => AssessmentHistoryModel(
              assessmentID: a.assessmentID,
              data: a.data,
              createdAt: a.createdAt,
              boardName: a.boardName,
              gradeName: a.gradeName,
              subjectName: a.subjectName,
              duration: a.duration,
              topics: a.topics,
            ))
        .toList();

    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HistoryFilterBar(
            selectedClass: _selectedClass,
            selectedSubject: _selectedSubject,
            availableClasses: _availableClasses,
            availableSubjects: _availableSubjects,
            searchController: _searchController,
            onClassChanged: (value) {
              setState(() => _selectedClass = value);
              _debounceTimer?.cancel();
              _applyFilters();
            },
            onSubjectChanged: (value) {
              setState(() => _selectedSubject = value);
              _debounceTimer?.cancel();
              _applyFilters();
            },
            onSearchSubmitted: () {
              _debounceTimer?.cancel();
              _applyFilters();
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: availableHeight > 400 ? availableHeight : 400,
            child: history.isEmpty
                ? const HistoryEmptyState(
                    screen: "assessments",
                  )
                : HistoryTable(
                    history: adaptedHistory,
                    scrollController: _horizontalScrollController,
                    onView: (lpItem) {
                      final matching = history.firstWhere(
                          (a) => a.assessmentID == lpItem.lessonPlanID,
                          orElse: () => history.first);
                      AssessmentHistoryPdfHandler.viewAssessmentHistory(
                          context, matching);
                    },
                    onDownload: (lpItem) {
                      final matching = history.firstWhere(
                          (a) => a.assessmentID == lpItem.lessonPlanID,
                          orElse: () => history.first);
                      AssessmentHistoryPdfHandler.downloadAssessmentHistory(
                          context, matching);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
