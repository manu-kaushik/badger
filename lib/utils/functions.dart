import 'package:flutter/material.dart';
import 'package:badger/utils/colors.dart';

import 'constants.dart';

Color colorFromString(String colorString) {
  int colorValue = int.parse(colorString.substring(8, 16), radix: 16);

  return Color(colorValue);
}

SnackBar getSnackBar(
  String message, {
  AlertTypes? type,
  SnackBarAction? action,
  Duration? duration,
  double? elevation = 0,
}) {
  MaterialColor getColor() {
    if (type == AlertTypes.success) {
      return Colors.green;
    } else if (type == AlertTypes.warn) {
      return Colors.orange;
    } else if (type == AlertTypes.error) {
      return Colors.red;
    } else if (type == AlertTypes.info) {
      return Colors.blue;
    } else {
      return themeColor;
    }
  }

  MaterialColor color = getColor();

  return SnackBar(
    content: Text(
      message,
      style: TextStyle(color: color),
    ),
    backgroundColor: color.shade50,
    action: action,
    duration: duration ?? const Duration(milliseconds: 4000),
    elevation: elevation,
  );
}

Size screenSize(context) => MediaQuery.of(context).size;
