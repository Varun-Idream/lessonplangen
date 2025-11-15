import 'package:flutter/material.dart';

import 'color_constants.dart';

late final String sp;

enum AppType {
  serverclient,
  standalone,
  online,
}

enum LessonPlanStatus {
  metaDataPostLoading,
  metaDataPostFailure,
  metaDataGetLoading,
  metaDataGet,
  metaDataGetFailure,
  finalizeDataPostLoading,
  finalizeDataPost,
  finalizeDataPostFailure,
  finalizeDataGetLoading,
  finalizeDataGet,
  finalizeDataGetFailure,
  generationDataPostLoading,
  generationDataPost,
  generationDataPostFailure,
  generationDataGetLoading,
  generationDataGet,
  generationDataGetFailure,
  exsists,
  limitReached,
  internalFailure,
}

enum AssessmentGenStatus {
  metaDataPostLoading,
  metaDataPostFailure,
  metaDataGetLoading,
  metaDataGet,
  metaDataGetFailure,
  finalizeDataPostLoading,
  finalizeDataPost,
  finalizeDataPostFailure,
  finalizeDataGetLoading,
  finalizeDataGet,
  finalizeDataGetFailure,
  generationDataPostLoading,
  generationDataPost,
  generationDataPostFailure,
  generationDataGetLoading,
  generationDataGet,
  generationDataGetFailure,
  exsists,
  limitReached,
  internalFailure,
}

abstract class TextStyles {
  static const textMedium15 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static const textMedium16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const textLight16WithFI = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: ColorConstants.grey,
    decoration: TextDecoration.none,
    fontFamily: "Inter",
  );
  static const textMedium18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static const textMedium20 = TextStyle(
    fontSize: 20,
    fontFamily: "Inter",
    fontWeight: FontWeight.w500,
  );
  static const textMedium24 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );
  static const textBold28WithFI = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.none,
    fontFamily: "Inter",
    color: ColorConstants.primaryBlack,
  );
  static const textSemiBold16Grey = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
    fontFamily: "Inter",
    color: ColorConstants.grey,
  );
  static const textMedium28 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );
  static const textRegular28 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  );
  static const textRegular24 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );
  static const textSemiBold24 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  static const textMedium22 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );
  static const textRegular22 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
  );
  static const textSemiBold22 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
  static const textSemiBold20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static const textSemiBold16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const textRegular18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  static const textRegular18Greyh3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: ColorConstants.mediumGrey,
    height: 3,
  );
  static const textRegular16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const textRegular11 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );
  static const textRegular12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const textRegular14Blue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ColorConstants.primaryBlue,
  );
  static const textRegular14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const textRegular15 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  static const textBold32 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
}
