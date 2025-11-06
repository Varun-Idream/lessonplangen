import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/custom_dropdown.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class HistoryFilterBar extends StatelessWidget {
  final String? selectedClass;
  final String? selectedSubject;
  final List<String> availableClasses;
  final List<String> availableSubjects;
  final TextEditingController searchController;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<String?> onSubjectChanged;
  final VoidCallback? onSearchSubmitted;

  const HistoryFilterBar({
    super.key,
    required this.selectedClass,
    required this.selectedSubject,
    required this.availableClasses,
    required this.availableSubjects,
    required this.searchController,
    required this.onClassChanged,
    required this.onSubjectChanged,
    this.onSearchSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: _FilterDropdown(
            label: 'All Class',
            value: selectedClass ?? 'All Class',
            items: availableClasses,
            onChanged: (value) =>
                onClassChanged(value == 'All Class' ? null : value),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 150,
          child: _FilterDropdown(
            label: 'All Subject',
            value: selectedSubject ?? 'All Subject',
            items: availableSubjects,
            onChanged: (value) =>
                onSubjectChanged(value == 'All Subject' ? null : value),
          ),
        ),
        const SizedBox(width: 16),
        const Spacer(),
        SizedBox(
          width: 150,
          child: _SearchBar(
            controller: searchController,
            onSubmitted: onSearchSubmitted,
          ),
        ),
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        decoration: BoxDecoration(
          color: ColorConstants.primaryWhite,
          border: Border.all(color: ColorConstants.lightGrey, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyles.textRegular14.copyWith(
              color: ColorConstants.mediumGrey3,
              fontFamily: "Inter",
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return CustomDropdown<String>(
      items: items,
      onChange: onChanged,
      itemBuilder: (count, item, index) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          item,
          style: TextStyles.textRegular14.copyWith(
            color: ColorConstants.primaryBlack,
            fontFamily: "Inter",
          ),
        ),
      ),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        decoration: BoxDecoration(
          color: ColorConstants.primaryWhite,
          border: Border.all(color: ColorConstants.lightGrey, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyles.textRegular14.copyWith(
                  color: ColorConstants.primaryBlack,
                  fontFamily: "Inter",
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: ColorConstants.primaryBlue,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmitted;

  const _SearchBar({
    required this.controller,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: ColorConstants.primaryWhite,
        border: Border.all(color: ColorConstants.lightGrey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        onSubmitted: (_) => onSubmitted?.call(),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyles.textRegular14.copyWith(
            color: ColorConstants.mediumGrey3,
            fontFamily: "Inter",
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.search,
              color: ColorConstants.mediumGrey3,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        ),
        style: TextStyles.textRegular14.copyWith(
          color: ColorConstants.primaryBlack,
          fontFamily: "Inter",
        ),
      ),
    );
  }
}
