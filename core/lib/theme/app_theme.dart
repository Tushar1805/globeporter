import 'package:flutter/material.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData primaryTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  // unselectedWidgetColor: Colors.white,
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(color: Colors.white),
    backgroundColor: primaryColor,
  ),
  cardTheme: CardThemeData(color: Colors.white),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
  ),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    minWidth: double.infinity,
    height: 60,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
  ),
  colorScheme: ColorScheme(
    tertiaryContainer: primaryColor,
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: secondaryColor,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.red,
    background: Colors.white,
    //onBackground: Colors.black,
    onBackground: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    shadow: Colors.white.withOpacity(0.9),
  ),
  //primarySwatch: Colors.deepPurple,
  textTheme: TextTheme(
    //For title and subtitle used in card and container
    titleLarge: GoogleFonts.lato(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    bodyLarge: GoogleFonts.lato(
      fontSize: 27,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.lato(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    bodySmall: GoogleFonts.lato(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    //For Main labels like Courses, Insights, etc on HomeScreen
    labelLarge: GoogleFonts.lato(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    //For Button
    labelMedium: GoogleFonts.lato(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    //For Bottom Nav Text
    labelSmall: GoogleFonts.lato(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.lato(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    displaySmall: GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  ),
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black38,
  unselectedWidgetColor: Colors.white,
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(color: Colors.white),
    backgroundColor: Colors.black,
  ),
  cardTheme: CardThemeData(
    //color: cardColor,
    color: Colors.white,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.black),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    minWidth: double.infinity,
    height: 60,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.black,
    elevation: 2,
  ),
  colorScheme: ColorScheme(
    tertiaryContainer: Colors.white,
    brightness: Brightness.dark,
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.black,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.red,
    background: Colors.black26,
    onBackground: Colors.black,
    surface: Colors.black38,
    onSurface: Colors.black,
    shadow: Colors.black.withOpacity(0.9),
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.lato(
      fontSize: 19,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.lato(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodySmall: GoogleFonts.lato(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    labelLarge: GoogleFonts.lato(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    labelMedium: GoogleFonts.lato(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    labelSmall: GoogleFonts.lato(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.lato(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
  ),
  useMaterial3: true,
);
