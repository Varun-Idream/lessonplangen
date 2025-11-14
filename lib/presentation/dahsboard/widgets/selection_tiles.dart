import 'package:flutter/material.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class SelectionTiles extends StatelessWidget {
  final VoidCallback? callback;
  final Widget? icon;
  final String title;
  final String subText;
  final Color borderColor;
  final double borderRadius;

  const SelectionTiles({
    super.key,
    this.callback,
    this.icon,
    this.title = '',
    this.subText = '',
    this.borderColor = ColorConstants.lightGrey3,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor),
        borderRadius: BorderRadiusGeometry.circular(borderRadius),
      ),
      child: InkWell(
        onTap: callback,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              if (icon != null) icon ?? SizedBox(),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyles.textMedium20.copyWith(
                  color: ColorConstants.primaryBlack,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subText,
                style: TextStyles.textMedium16.copyWith(
                  color: ColorConstants.lightGrey3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
