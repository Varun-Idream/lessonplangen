import 'package:flutter/material.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorConstants.lightGrey2),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const Hamburger(),
              const SizedBox(width: 5),
        ],
      ),
    );
  }
}

class Hamburger extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  const Hamburger({
    super.key,
    this.padding = const EdgeInsets.all(10),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      shape: const CircleBorder(
        side: BorderSide(
          color: ColorConstants.lightGrey2,
        ),
      ),
      color: Colors.transparent,
      child: InkWell(
        canRequestFocus: false,
        onTap: () {
          final parentScaffold = Scaffold.of(context);
          if (!parentScaffold.isDrawerOpen) {
            parentScaffold.openDrawer();
          }
        },
        child: Container(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 2,
                width: 7,
                color: ColorConstants.lightGrey3,
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: 2,
                width: 10,
                color: ColorConstants.lightGrey3,
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: 2,
                width: 13,
                color: ColorConstants.lightGrey3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
