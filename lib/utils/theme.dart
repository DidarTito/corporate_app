import 'package:flutter/material.dart';
import 'constants.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primaryBlue,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryBlue,
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.primaryBlue,
    unselectedItemColor: AppColors.grey,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColors.primaryBlue,
  ),
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: AppColors.primaryBlue,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryDarkBlue,
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryDarkBlue,
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF1E1E1E),
    selectedItemColor: AppColors.primaryBlue,
    unselectedItemColor: Colors.grey.shade400,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),
  cardTheme: CardThemeData(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: const Color(0xFF1E1E1E),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: const Color(0xFF1E1E1E),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Color(0xFF2D2D2D),
    filled: true,
  ),
  dividerColor: Colors.grey.shade800,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryBlue,
    secondary: AppColors.primaryBlue,
    surface: const Color(0xFF1E1E1E),
    background: const Color(0xFF121212),
  ),
);