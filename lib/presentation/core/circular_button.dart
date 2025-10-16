import 'package:flutter/material.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

class CircularButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color iconGestureColor;
  final EdgeInsetsGeometry padding;
  final Widget? icon;
  final int backgroundAlpha;

  const CircularButton({
    super.key,
    this.onTap,
    this.iconGestureColor = ColorConstants.primaryBlue,
    this.padding = const EdgeInsets.all(5.0),
    this.icon,
    this.backgroundAlpha = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: iconGestureColor.withAlpha(backgroundAlpha),
      shape: CircleBorder(side: BorderSide(color: iconGestureColor)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        canRequestFocus: false,
        onTap: onTap,
        child: Container(
          padding: padding,
          child: icon,
        ),
      ),
    );
  }
}
