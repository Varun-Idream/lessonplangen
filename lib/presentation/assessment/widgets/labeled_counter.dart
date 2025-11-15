import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/labeled_custom_field.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class LabeledCounter extends StatelessWidget {
  final ValueNotifier notifier;
  final String label;
  final bool isRequired;
  final double maxWidth;
  final Border? border;
  final double borderRadius;

  const LabeledCounter({
    super.key,
    required this.notifier,
    this.label = '',
    this.isRequired = true,
    this.maxWidth = 350,
    this.border,
    this.borderRadius = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return LabeledCustomField(
      isRequired: isRequired,
      label: label,
      child: Container(
        padding: const EdgeInsetsGeometry.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          border: border ??
              Border.all(
                color: ColorConstants.lightGrey,
                width: 1,
              ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                if (notifier.value > 0) {
                  notifier.value -= 1;
                }
              },
              icon: Icon(Icons.remove),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    side: BorderSide(
                      color: ColorConstants.lightGrey,
                      width: 1,
                    ),
                    borderRadius: BorderRadiusGeometry.circular(
                      6.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: notifier,
                builder: (context, value, child) {
                  return Text(
                    "$value",
                    style: TextStyles.textMedium16,
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
            const SizedBox(width: 5),
            IconButton(
              onPressed: () {
                notifier.value += 1;
              },
              icon: Icon(Icons.add),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    side: BorderSide(
                      color: ColorConstants.lightGrey,
                      width: 1,
                    ),
                    borderRadius: BorderRadiusGeometry.circular(
                      6.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
