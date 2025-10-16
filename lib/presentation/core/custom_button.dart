import 'package:flutter/material.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final String title;
  final Widget? titleWidget;
  final Color backgroundColor;
  final Color textColor;
  final double? width;

  const CustomButton({
    super.key,
    this.onTap,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.title = '',
    this.titleWidget,
    this.backgroundColor = ColorConstants.primaryBlue,
    this.textColor = ColorConstants.primaryWhite,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          padding: const EdgeInsets.all(16),
          child: titleWidget ??
              Text(
                title,
                style: TextStyles.textRegular14.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
        ),
      ),
    );
  }
}
