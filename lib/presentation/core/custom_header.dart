import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/svg_widget.dart';
import 'package:lessonplan/util/constants/assets.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

import 'circular_button.dart';

class CommonHeader extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry headerPadding;
  const CommonHeader({
    super.key,
    this.title = '',
    this.headerPadding = const EdgeInsets.symmetric(
      vertical: 15,
      horizontal: 10,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: headerPadding,
      decoration: const BoxDecoration(
        color: ColorConstants.primaryWhite,
        border: Border(
          bottom: BorderSide(
            color: ColorConstants.lightGrey2,
          ),
        ),
      ),
      child: Row(
        children: [
          CircularButton(
            padding: const EdgeInsets.all(10),
            icon: const SizedBox(
              height: 15,
              width: 15,
              child: AssetSvg(Assets.backarrow),
            ),
            iconGestureColor: ColorConstants.lightGrey5,
            onTap: () {
              context.router.maybePop();
            },
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyles.textMedium20.copyWith(
              color: ColorConstants.primaryBlack,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
