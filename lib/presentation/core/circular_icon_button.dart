import 'package:flutter/material.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

class CircularIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color iconColor;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final IconData iconData;
  final Color? borderColor;
  final Color? backgroundColor;

  const CircularIconButton({
    super.key,
    this.onTap,
    this.iconColor = ColorConstants.primaryBlue,
    this.padding = const EdgeInsets.all(5.0),
    this.iconSize = 20,
    required this.iconData,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? iconColor.withAlpha(20),
      shape: CircleBorder(
        side: BorderSide(color: borderColor ?? iconColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        canRequestFocus: false,
        onTap: onTap,
        child: Container(
          padding: padding,
          child: Icon(
            iconData,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
