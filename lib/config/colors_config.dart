import 'dart:ui';

import 'package:flutter/material.dart';

/// This is a representation of our Zeplin styleguide:
/// https://app.zeplin.io/project/5ee0eecf07506ab29838afb3/styleguide
class Styleguide {
  static Color nearBackground(ThemeData theme) =>
      theme.brightness == Brightness.light
          ? Styleguide.color_gray_1
          : Styleguide.color_gray_8;

  //
  // Color(0xaarrggbb)
  //
  static const Color color_gray_0 = Color(0xffffffff);
  static const Color color_gray_1 = Color(0xfff7f7f7);
  static const Color color_gray_2 = Color(0xffdfdfdf);
  static const Color color_gray_3 = Color(0xff949494);
  static const Color color_gray_4 = Color(0xff6a6a6a);
  static const Color color_gray_5 = Color(0xff4c4c4c);
  // color_gray_8 is not part of original style guide
  static const Color color_gray_8 = Color(0xff2f2f2f);
  static const Color color_gray_9 = Color(0xff272727);

  static const Color color_green_1 = Color(0xff00a64b);
  static const Color color_green_2 = Color(0xff008c44);
  static const Color color_green_3 = Color(0xff006c2b);
  static const Color color_green_4 = Color(0xff1d5632);
  static const Color color_green_5 = Color(0xff0b3f1f);
  static const Color color_green_6 = Color(0xff004c1c);
  static const Color color_green_7 = Color(0xff336646);
  static const Color color_green_8 = Color(0xff15753e);

  static Color color_orange_1 = Color(0xffFEF7EC);
  static Color color_orange_2 = Color(0xffFDA503);

  static Color color_red_1 = Color(0xffF5EEEF);
  static Color color_red_2 = Color(0xff74272b);

  static Color color_blue_1 = Color(0xffECF6FA);
  static Color color_blue_2 = Color(0xff1580c4);

  static Color color_yellow_1 = Color(0xffFEFAEB);
  static Color color_yellow_2 = Color(0xffFDCB04);
  static const Color color_accents_yellow_1_8 = Color(0xfec324);

  static const Color color_accents_blue_1 = Color(0xff699fd5);
  static const Color color_accents_blue_2 = Color(0xff4b88c5);
  static const Color color_accents_blue_3 = Color(0xff33699f);
  static const Color color_accents_blue_4 = Color(0xff1e497f);
  static const Color color_accents_blue_5 = Color(0xff073773);

  static const Color color_accents_yellow_1 = Color(0xfffec324);
  static const Color color_accents_yellow_2 = Color(0xffffa716);
  static const Color color_accents_yellow_3 = Color(0xfff48326);

  static const Color color_accents_light_green = Color(0xff8cc63f);

  static const Color color_accents_red = Color(0xffe52f52);
  static const Color color_light_navy_8 = Color(0x114a92);

  static const Color color_transparent = Color(0x00000000);
}
