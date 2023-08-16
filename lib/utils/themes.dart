import 'package:flutter/material.dart';
import 'package:badger/utils/colors.dart';

ThemeData theme = ThemeData(
  primaryColor: primaryColor,
  primarySwatch: primaryColor,
  fontFamily: 'Inter',
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: const TextStyle(color: Colors.white),
  ),
  scaffoldBackgroundColor: primaryColor,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: secondaryColor,
    elevation: 0,
  ),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: TextStyle(color: secondaryColor),
    backgroundColor: primaryColor.shade700,
  ),
);
