import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lessonplan/bloc/lessonplan_history/lesson_plan_history_cubit.dart';
import 'package:lessonplan/models/lesson_plan_history_model.dart';
import 'package:lessonplan/services/injection/getit.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/history/history_filter_bar.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/history/history_table.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/history/history_empty_state.dart';
import 'package:lessonplan/presentation/lessonplan/widgets/history/history_pdf_handler.dart';

class LessonPlanHistory extends StatefulWidget {
  const LessonPlanHistory({super.key});

  @override
  State<LessonPlanHistory> createState() => _LessonPlanHistoryState();
}

class _LessonPlanHistoryState extends State<LessonPlanHistory> {
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
      sl<LessonPlanHistoryCubit>().loadHistory();
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
    sl<LessonPlanHistoryCubit>().applyFilters(
      gradeName: _selectedClass,
      subjectName: _selectedSubject,
      searchQuery: _searchController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<LessonPlanHistoryCubit>(),
      child: BlocConsumer<LessonPlanHistoryCubit, LessonPlanHistoryState>(
        listener: _handleStateChanges,
        builder: _buildContent,
      ),
    );
  }

  void _handleStateChanges(BuildContext context, LessonPlanHistoryState state) {
    if (state is LessonPlanHistoryLoadedState) {
      final cubit = context.read<LessonPlanHistoryCubit>();
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

  Widget _buildContent(BuildContext context, LessonPlanHistoryState state) {
    if (state is LessonPlanHistoryLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is LessonPlanHistoryErrorState) {
      return Center(
        child: Text(
          state.errorMessage,
          style: TextStyles.textRegular16.copyWith(
            color: ColorConstants.primaryRed,
          ),
        ),
      );
    }

    if (state is LessonPlanHistoryLoadedState) {
      return _buildHistoryContent(state.history);
    }

    return const SizedBox.shrink();
  }

  Widget _buildHistoryContent(List<LessonPlanHistoryModel> history) {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - 200;

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
                ? const HistoryEmptyState()
                : HistoryTable(
                    history: history,
                    scrollController: _horizontalScrollController,
                    onView: (item) =>
                        HistoryPdfHandler.viewLessonPlan(context, item),
                    onDownload: (item) =>
                        HistoryPdfHandler.downloadLessonPlan(context, item),
                  ),
          ),
        ],
      ),
    );
  }
}
