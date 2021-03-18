import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors_config.dart';

class ThemeConfig {
  // Use HSV color space for proper LERPing.
  static Color _lerp(Color a, Color b, double t) =>
      HSVColor.lerp(HSVColor.fromColor(a), HSVColor.fromColor(b), t).toColor();

  static ThemeData createTheme(
    ColorScheme colorScheme,
  ) {
    final baseTextTheme = colorScheme.brightness == Brightness.dark
        ? Typography.blackMountainView
        : Typography.whiteMountainView;

    final onBackground50 = _lerp(
      colorScheme.background,
      colorScheme.onBackground,
      0.50,
    );

    final onBackground25 = _lerp(
      colorScheme.background,
      colorScheme.onBackground,
      0.25,
    );

    final onBackground15 = _lerp(
      colorScheme.background,
      colorScheme.onBackground,
      0.15,
    );

    final shadow = Styleguide.color_gray_9;

    final textTheme = _createTextTheme(baseTextTheme, colorScheme);
    return ThemeData(
      brightness: colorScheme.brightness,
      backgroundColor: colorScheme.background,
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      accentColor: colorScheme.secondary,
      disabledColor: onBackground50,
      toggleableActiveColor: colorScheme.primary,
      tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: colorScheme.onPrimary,
          ),
        ),
      ),
      dividerColor: onBackground15,
      dividerTheme: DividerThemeData(
        color: onBackground15,
        space: 1,
        thickness: 1,
        indent: 0,
        endIndent: 0,
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        shadowColor: shadow,
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        brightness: colorScheme.brightness,
        color: colorScheme.background,
      ),
      iconTheme: IconThemeData(
        size: 16.0,
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        colorScheme: colorScheme,
        height: 52,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: colorScheme.brightness,
        primaryColor: colorScheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: onBackground25,
            style: BorderStyle.solid,
            width: 0.5,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: onBackground25,
            style: BorderStyle.solid,
            width: 0.5,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        labelStyle: baseTextTheme.subtitle1.copyWith(
          color: onBackground50,
          fontFamily: 'ProximaNova',
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        hintStyle: baseTextTheme.subtitle1.copyWith(
          color: onBackground50,
          fontFamily: 'ProximaNova',
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
      ),
      hintColor: onBackground50,
      fontFamily: 'ProximaNova',
      textTheme: textTheme,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.primary,
        elevation: 4.0,
        selectedItemColor: Styleguide.color_gray_0,
        unselectedItemColor: Styleguide.color_gray_0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle:
            textTheme.caption.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle:
            textTheme.caption.copyWith(fontWeight: FontWeight.w300),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static TextTheme _createTextTheme(
      TextTheme baseTextTheme, ColorScheme colorScheme) {
    return TextTheme(
      headline1: baseTextTheme.headline1.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 28,
        fontWeight: FontWeight.w800,
      ),
      headline2: baseTextTheme.headline2.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 24,
        fontWeight: FontWeight.w800,
      ),
      headline3: baseTextTheme.headline3.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      headline4: baseTextTheme.headline4.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
      headline5: baseTextTheme.headline5.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
      headline6: baseTextTheme.headline6.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
      bodyText1: baseTextTheme.bodyText1.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      bodyText2: baseTextTheme.bodyText2.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      button: baseTextTheme.button.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      caption: baseTextTheme.caption.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
      overline: baseTextTheme.overline.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
      subtitle1: baseTextTheme.subtitle1.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      subtitle2: baseTextTheme.subtitle2.copyWith(
        color: colorScheme.onBackground,
        fontFamily: 'ProximaNova',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static ThemeData get lightTheme => createTheme(
        ColorScheme(
          brightness: Brightness.light,
          background: Styleguide.color_gray_0,
          onBackground: Styleguide.color_gray_9,
          surface: Styleguide.color_gray_0,
          onSurface: Styleguide.color_gray_9,
          primary: Styleguide.color_green_4,
          primaryVariant: Styleguide.color_green_5,
          onPrimary: Styleguide.color_gray_0,
          secondary: Styleguide.color_accents_yellow_2,
          secondaryVariant: Styleguide.color_accents_yellow_3,
          onSecondary: Styleguide.color_gray_9,
          error: Styleguide.color_accents_red,
          onError: Styleguide.color_gray_0,
        ),
      );

  static ThemeData get darkTheme => createTheme(
        ColorScheme(
          brightness: Brightness.dark,
          background: Styleguide.color_gray_9,
          onBackground: Styleguide.color_gray_1,
          surface: Styleguide.color_gray_8,
          onSurface: Styleguide.color_gray_0,
          primary: Styleguide.color_green_2,
          primaryVariant: Styleguide.color_green_3,
          onPrimary: Styleguide.color_gray_0,
          secondary: Styleguide.color_accents_yellow_1,
          secondaryVariant: Styleguide.color_accents_yellow_2,
          onSecondary: Styleguide.color_gray_9,
          error: Styleguide.color_accents_red,
          onError: Styleguide.color_gray_0,
        ),
      );
}
