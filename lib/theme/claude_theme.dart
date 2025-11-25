import 'package:flutter/material.dart';

const claudeOrange = Color(0xFFC96442);
const claudeOrangeDark = Color(0xFFC96442);

const claudeSurface = Color(0xFFF7F7F8);
const claudeSurfaceDark = Color(0xFF1A1A1C);

const claudeText = Color(0xFF1A1A1C);
const claudeTextDark = Color(0xFFE8E8EA);

const claudeBorder = Color(0xFFE1E1E4);
const claudeBorderDark = Color(0xFF303033);

const claudeCardLight = Colors.white;
const claudeCardDark = Color(0xFF30302E);

final ThemeData claudeLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: claudeSurface,
  primaryColor: claudeOrange,
  appBarTheme: const AppBarTheme(
    backgroundColor: claudeSurface,
    foregroundColor: claudeText,
    elevation: 0,
  ),
  cardColor: claudeCardLight,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: claudeText, fontSize: 16),
    bodyLarge: TextStyle(color: claudeText, fontSize: 18),
  ),
  dividerColor: claudeBorder,
  colorScheme: const ColorScheme.light(
    primary: claudeOrange,
    secondary: claudeOrange,
    surface: claudeSurface,
    onSurface: claudeText,
  ),
);

final ThemeData claudeDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: claudeSurfaceDark,
  primaryColor: claudeOrangeDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: claudeSurfaceDark,
    foregroundColor: claudeTextDark,
    elevation: 0,
  ),
  cardColor: claudeCardDark,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: claudeTextDark, fontSize: 16),
    bodyLarge: TextStyle(color: claudeTextDark, fontSize: 18),
  ),
  dividerColor: claudeBorderDark,
  colorScheme: const ColorScheme.dark(
    primary: claudeOrangeDark,
    secondary: claudeOrangeDark,
    surface: claudeSurfaceDark,
    onSurface: claudeTextDark,
  ),
);
