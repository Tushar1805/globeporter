import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Lato',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(primary: Colors.blue, secondary: Colors.green),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.blue, foregroundColor: Colors.white),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    // primaryColor: CustomColors.primaryGreen,
    // scaffoldBackgroundColor: CustomColors.backgroundColor,
    // colorScheme: ColorScheme.dark(
    //   primary: CustomColors.primaryGreen,
    //   secondary: CustomColors.secondaryGreen,
    //   surface: CustomColors.surfaceColor,
    //   onPrimary: CustomColors.textPrimary,
    //   onSecondary: CustomColors.textSecondary,
    //   error: CustomColors.errorColor,
    //   onError: CustomColors.textPrimary,
    //   primaryFixed: Colors.white,
    //   primaryContainer: CustomColors.greyColor,
    //   secondaryContainer: CustomColors.chatGreenColor,
    // ),
    // appBarTheme: AppBarTheme(backgroundColor: CustomColors.backgroundColor, foregroundColor: CustomColors.textPrimary),
    // textTheme: TextTheme(
    //   bodyLarge: TextStyle(color: CustomColors.textPrimary),
    //   bodyMedium: TextStyle(color: CustomColors.textSecondary),
    // ),
    // disabledColor: CustomColors.borderColor,
    // dividerColor: CustomColors.borderColor,
    // cardColor: CustomColors.transparentSurface,
    // iconTheme: IconThemeData(color: CustomColors.accentTeal),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   backgroundColor: CustomColors.primaryGreen,
    //   foregroundColor: CustomColors.textPrimary,
    // ),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: CustomColors.primaryGreen,
    //     foregroundColor: CustomColors.textPrimary,
    //   ),
    // ),
  );
}
