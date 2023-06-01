import 'package:flutter/material.dart';
import 'package:badger/utils/colors.dart';

ThemeData theme = ThemeData(
  primaryColor: themeColor,
  primarySwatch: themeColor,
  fontFamily: 'Quicksand',
  appBarTheme: AppBarTheme(
    backgroundColor: themeColor.shade50,
    elevation: 0,
    iconTheme: IconThemeData(color: themeColor),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: themeColor,
    elevation: 0,
  ),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: TextStyle(color: themeColor),
    backgroundColor: themeColor.shade50,
  ),
);
