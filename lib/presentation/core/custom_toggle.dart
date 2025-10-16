import 'package:flutter/material.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

class ToggleTabs {
  final String label;

  const ToggleTabs({
    this.label = 'tab',
  });
}

class CustomToggle extends StatefulWidget {
  final List<ToggleTabs> toggleTabs;
  final Size labelSize;
  final TextStyle labelStyle;
  final EdgeInsetsGeometry labelPadding;
  final EdgeInsetsGeometry margin;
  final Color backgroundColor;
  final double borderRadius;
  final int selectedIndex;
  final Function(int index) onChanged;

  const CustomToggle({
    super.key,
    this.toggleTabs = const [],
    this.labelPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
    this.labelSize = const Size(200, 45),
    this.labelStyle = const TextStyle(
      color: ColorConstants.primaryBlue,
    ),
    this.margin = EdgeInsets.zero,
    this.backgroundColor = ColorConstants.backgroundBlue2,
    this.borderRadius = 30,
    this.selectedIndex = 0,
    required this.onChanged,
  });

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  double _currentIndicatorX = 0.0;

  @override
  Widget build(BuildContext context) {
    final double targetIndicatorX =
        widget.selectedIndex * widget.labelSize.width;
    final double totalWidth = widget.toggleTabs.length * widget.labelSize.width;

    return TweenAnimationBuilder(
      curve: Curves.easeInOutCirc,
      tween: Tween<double>(begin: _currentIndicatorX, end: targetIndicatorX),
      duration: const Duration(milliseconds: 300),
      builder: (context, animatedX, child) {
        _currentIndicatorX = animatedX;

        return Container(
          width: totalWidth,
          height: widget.labelSize.height,
          decoration: BoxDecoration(
            color: ColorConstants.backgroundBlue2,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          margin: widget.margin,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                left: animatedX,
                child: Container(
                  width: widget.labelSize.width,
                  height: widget.labelSize.height,
                  padding: widget.labelPadding,
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryBlue,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                ),
              ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  final double whiteStripeStart = animatedX / totalWidth;
                  final double whiteStripeEnd =
                      (animatedX + widget.labelSize.width) / totalWidth;

                  return LinearGradient(
                    colors: const [
                      ColorConstants.primaryBlue,
                      ColorConstants.primaryBlue,
                      ColorConstants.primaryWhite,
                      ColorConstants.primaryWhite,
                      ColorConstants.primaryBlue,
                      ColorConstants.primaryBlue,
                    ],
                    stops: [
                      0.0,
                      whiteStripeStart,
                      whiteStripeStart,
                      whiteStripeEnd,
                      whiteStripeEnd,
                      1.0,
                    ],
                  ).createShader(bounds);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(widget.toggleTabs.length, (index) {
                    return InkWell(
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      onTap: () => widget.onChanged(index),
                      child: Container(
                        width: widget.labelSize.width,
                        height: widget.labelSize.height,
                        alignment: Alignment.center,
                        padding: widget.labelPadding,
                        child: Text(
                          widget.toggleTabs[index].label,
                          style: widget.labelStyle,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Indicator extends StatelessWidget {
  final Size size;
  final double borderRadius;
  const Indicator({
    super.key,
    this.size = const Size(180, 60),
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
          color: ColorConstants.primaryBlue,
          borderRadius: BorderRadius.circular(borderRadius)),
    );
  }
}
