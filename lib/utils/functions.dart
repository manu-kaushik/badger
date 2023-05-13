import 'package:flutter/material.dart';
import 'package:notes/utils/colors.dart';

import 'constants.dart';

Color colorFromString(String colorString) {
  int colorValue = int.parse(colorString.substring(8, 16), radix: 16);

  return Color(colorValue);
}

SnackBar getSnackBar(String message, {AlertTypes? type}) {
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
      return darkColor;
    }
  }

  return SnackBar(
    content: Text(
      message,
      style: TextStyle(color: getColor()),
    ),
    backgroundColor: getColor().shade50,
  );
}
