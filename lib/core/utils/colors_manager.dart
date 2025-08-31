// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ColorsManager {
  static const Color kAppBarBackgroundColor = Color(0xFFB2FCFE);
  static const Color kPrimaryColor = Color(0xFF2E95B4);
  static const Color kTextGrey = Color(0xFF868686);
  static const Color kHintTextGrey = Color(0xFFADADAD);
  static const Color kBottomNavTextGrey = Color(0xFFC5C9D0);
  static const Color kBlack = Color(0xFF000000);
  static const Color kWhite = Color(0xFFFFFFFF);
  static const Color kRed = Color(0xFFFF0000);
  static const Color kGold = Color(0xFFFF991F);

  static MaterialColor convColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
