import 'package:flutter/painting.dart';

abstract class ColorConstants {
  static const Color thinGrey = Color(0xFFF1F1F1);
  static const Color thinGrey2 = Color(0xFFFAFAFA);
  static const Color lightGrey = Color(0xFFDEDEDE);
  static const Color lightGrey2 = Color(0xFFE1E1E1);
  static const Color grey = Color(0xFF666666);
  static const Color lightGrey3 = Color(0xFF939393);
  static const Color lightGrey5 = Color(0xFFC9C9C9);
  static const Color lightGrey9 = Color(0xFF9E9E9E);
  static const Color lightGrey7 = Color(0xFFD6D6D6);
  static const Color lightGrey4 = Color(0xFFFAF1E3);
  static const Color mediumGrey = Color(0xFF565657);
  static const Color mediumGrey2 = Color(0xFF707070);
  static const Color mediumGrey3 = Color(0xFF666666);
  static const Color mediumGrey4 = Color(0xFF5E5E5E);
  static const Color primaryBlack = Color(0xFF212121);
  static const Color trueBlack = Color(0xFF000000);
  static const Color darkBlue = Color(0xFF0077FF);
  static const Color darkGrey = Color(0xFF5F5D5D);
  static const Color lightBackgroundBlue = Color(0xFFFBFDFF);
  static const Color tertiaryBgBlue = Color(0xFFF1F8FF);
  static const Color lightShadowColor = Color(0xFFF2F8FF);
  static const Color primaryBlue = Color(0xFF0077FF);
  static const Color lightBackgroundBlue2 = Color(0xFFE2E8F0);
  static const Color primaryBackgroundBlue = Color(0xFFD1E6FF);
  static const Color selectionBlue = Color(0x150077FF);
  static const Color secondaryBlue = Color(0xFF3399FF);
  static const Color lightBlue = Color(0x0D0077FF);
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color blueGrey = Color(0xAAE6F8F4);
  static const Color naturalGreen = Color(0xFF41B183);
  static const Color secondaryGreen = Color(0xFF22C59B);
  static const Color darkGreen = Color(0xFF1F8450);
  static const Color quarternaryBlue = Color(0x133399FF);
  static const Color correctGradient = Color(0xFFF8FFFD);
  static const Color incorrectGradient = Color(0x0DFF6F6F);
  static const Color tertiaryGreen = Color(0xFFDBF7F0);
  static const Color lightGreen = Color(0xFFD6EB84);
  static const Color primaryYellow = Color(0xFFFDC500);
  static const Color primaryOrange = Color(0xFFFB9E36);
  static const Color secondaryOrange = Color(0x50FB9E36);
  static const Color primaryRed = Color(0xFFFF0000);
  static const Color lightGrey8 = Color(0xFFE8E8E8);
  static const Color primaryTeal = Color(0xFF0b94b6);
  static const Color secondaryTeal = Color(0x300b94b6);
  static const Color backgroundBlue2 = Color(0xFFF5FAFF);

  static const List<Color> gradient = [
    Color(0x000077FF),
    Color(0x050077FF),
    Color(0x100077FF),
    Color(0x150077FF),
    Color(0x200077FF),
  ];

  static const List<Color> gradientProfile = [
    Color(0x20707070),
    Color(0x050077FF),
    Color(0x100077FF),
    Color(0x150077FF),
    Color(0x200077FF),
  ];

  static const List<Color> gradientIP = [
    Color(0xFF5BA7FF),
    Color(0xFF9DCBFF),
    Color(0xFFDBECFF),
    Color(0xFFEEF6FF),
    Color(0xFFFFFFFF),
  ];

  static const List<Color> bannerGradient = [
    Color(0xFFF5F9FF),
    Color(0xFFE5F1FF),
  ];

  //language colors
  static const Map<String, Color> languageColors = {
    'english': tertiaryGreen,
    'english_secondary': secondaryGreen,
    'hindi': secondaryOrange,
    'hindi_secondary': primaryOrange,
    'kannada': secondaryOrange,
    'kannada_secondary': primaryOrange,
    'tamil': secondaryOrange,
    'tamil_secondary': primaryOrange,
    'assamese': secondaryOrange,
    'assamese_secondary': primaryOrange,
    'malayalam': secondaryOrange,
    'malayalam_secondary': primaryOrange,
    'bengali': secondaryTeal,
    'bengali_secondary': primaryTeal,
    'odia': secondaryOrange,
    'odia_secondary': primaryOrange,
  };
}
