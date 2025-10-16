import 'package:flutter/material.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

class LabeledCustomField<T> extends StatelessWidget {
  final bool isRequired;
  final String label;
  final TextStyle? labelStyle;
  final Axis axis;
  final Widget child;

  const LabeledCustomField({
    super.key,
    this.isRequired = false,
    this.label = 'Label',
    this.labelStyle,
    this.axis = Axis.vertical,
    required this.child,
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
        child,
      ],
    );
  }
}
