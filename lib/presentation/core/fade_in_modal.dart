import 'package:flutter/widgets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

class FadeInModal extends StatelessWidget {
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double maxWidth;
  final Color backgroundColor;
  final bool scrollable;
  final Widget? child;

  const FadeInModal({
    super.key,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(20),
    this.maxWidth = double.infinity,
    this.backgroundColor = ColorConstants.primaryWhite,
    this.scrollable = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: Container(
                clipBehavior: Clip.antiAlias,
                padding: padding,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                constraints: BoxConstraints(
                  maxHeight: size.height * 0.9,
                  maxWidth: maxWidth,
                ),
                child: scrollable ? SingleChildScrollView(child: child) : child,
              ),
            ),
          );
        },
        child: child,
      ),
    );
  }
}
