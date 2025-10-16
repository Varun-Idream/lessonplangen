import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/custom_button.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

class CustomTimePickerDialog extends StatefulWidget {
  const CustomTimePickerDialog({super.key});

  @override
  State<CustomTimePickerDialog> createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  int _selectedHour = 0;
  int _selectedMinute = 0;

  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: const Text(
          'Enter Time',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Inter",
            color: ColorConstants.primaryBlack,
          ),
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimePickerColumn(
            label: 'Hours',
            value: _selectedHour,
            onChanged: (newValue) {
              setState(() {
                _selectedHour = newValue!;
              });
            },
            items: List.generate(24, (index) => index),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              ':',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          _buildTimePickerColumn(
            label: 'Minute',
            value: _selectedMinute,
            onChanged: (newValue) {
              setState(() {
                _selectedMinute = newValue!;
              });
            },
            items: List.generate(60, (index) => index),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
      actions: [
        CustomButton(
          title: 'Cancel',
          backgroundColor: ColorConstants.primaryWhite,
          textColor: ColorConstants.primaryBlue,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(width: 10),
        CustomButton(
          title: 'Apply',
          onTap: () {
            final selectedTime =
                TimeOfDay(hour: _selectedHour, minute: _selectedMinute);
            Navigator.of(context).pop(selectedTime);
          },
        ),
      ],
    );
  }

  Widget _buildTimePickerColumn({
    required String label,
    required int value,
    required ValueChanged<int?> onChanged,
    required List<int> items,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              borderRadius: BorderRadius.circular(8.0),
              value: value,
              items: items.map((int val) {
                return DropdownMenuItem<int>(
                  value: val,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 10,
                    ),
                    child: Text(
                      _formatNumber(val),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}
