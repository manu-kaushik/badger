import 'package:flutter/material.dart';

Color colorFromString(String colorString) {
  int colorValue = int.parse(colorString.substring(8, 16), radix: 16);

  return Color(colorValue);
}
