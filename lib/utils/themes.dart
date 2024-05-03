import 'package:badger/utils/colors.dart';
import 'package:flutter/material.dart';

ThemeData theme = ThemeData.light().copyWith(
  textTheme: Typography().black.apply(fontFamily: 'Inter'),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: primaryColor.shade100,
    contentTextStyle: const TextStyle(
      color: Colors.black,
    ),
    elevation: 0,
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: Typography().white.apply(fontFamily: 'Inter'),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.black,
    contentTextStyle: TextStyle(
      color: Colors.white,
    ),
    elevation: 0,
  ),
);
