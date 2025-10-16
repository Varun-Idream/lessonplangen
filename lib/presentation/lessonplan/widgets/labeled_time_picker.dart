import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

class LabeledTimePicker extends StatelessWidget {
  final ValueListenable listenable;
  final String label;
  final TextStyle? labelStyle;
  final bool isRequired;
  final String hintText;
  final VoidCallback? onTap;

  const LabeledTimePicker({
    super.key,
    required this.listenable,
    this.label = '',
    this.labelStyle,
    this.isRequired = true,
    this.hintText = '',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: listenable,
        builder: (context, value, child) {
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
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 340,
                  constraints: BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorConstants.lightGrey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            value?.toString() ?? hintText,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  (value == null || value!.toString().isEmpty)
                                      ? ColorConstants.grey
                                      : ColorConstants.primaryBlack,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
