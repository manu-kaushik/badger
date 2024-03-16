import 'package:flutter/material.dart';

ThemeData theme = ThemeData.light().copyWith(
  textTheme: Typography().black.apply(fontFamily: 'Inter'),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: Typography().white.apply(fontFamily: 'Inter'),
);
