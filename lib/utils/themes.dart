import 'package:flutter/material.dart';

ThemeData theme = ThemeData.light().copyWith(
  textTheme: Typography().black.apply(fontFamily: 'Inter'),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey.shade200,
    contentTextStyle: const TextStyle(
      color: Colors.black,
    ),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: Typography().white.apply(fontFamily: 'Inter'),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.grey,
    contentTextStyle: TextStyle(
      color: Colors.black,
    ),
  ),
);
