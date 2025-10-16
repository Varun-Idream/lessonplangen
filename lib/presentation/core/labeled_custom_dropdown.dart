import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/custom_dropdown.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

class LabeledCustomDropdpwn<T> extends StatelessWidget {
  final bool isRequired;
  final String label;
  final TextStyle? labelStyle;
  final Axis axis;
  final List<T> items;
  final Widget child;
  final void Function(T value) onChange;
  final Widget Function(int count,T item, int index) itemBuilder;

  const LabeledCustomDropdpwn({
    super.key,
    this.isRequired = false,
    this.label = 'Label',
    this.labelStyle,
    this.axis = Axis.vertical,
    required this.items,
    required this.child,
    required this.onChange,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: labelStyle ??
                  TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.mediumGrey3,
                  ),
            ),
            const SizedBox(width: 4),
            if (isRequired)
              Text(
                '*',
                style: labelStyle?.copyWith(
                      color: Colors.red,
                    ) ??
                    TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ).copyWith(
                      color: Colors.red,
                    ),
              )
          ],
        ),
        const SizedBox(height: 14),
        CustomDropdown(
          items: items,
          onChange: onChange,
          itemBuilder: itemBuilder,
          child: child,
        ),
      ],
    );
  }
}
