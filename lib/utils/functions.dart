import 'package:flutter/material.dart';

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
  return SnackBar(
    content: Text(
      message,
    ),
    action: action,
    duration: duration ?? const Duration(milliseconds: 4000),
    elevation: elevation,
  );
}

Size screenSize(context) => MediaQuery.of(context).size;

String textToMarkdown(style, text) {
  if (style == MarkdownStyles.bold) {
    return '**$text**';
  } else if (style == MarkdownStyles.italic) {
    return '*$text*';
  } else if (style == MarkdownStyles.strikeThrough) {
    return '~~$text~~';
  } else if (style == MarkdownStyles.blockQuote) {
    return '> $text';
  } else if (style == MarkdownStyles.divider) {
    return '---\n$text';
  } else if (style == MarkdownStyles.code) {
    return '```\n$text\n```\n';
  } else if (style == MarkdownStyles.inlineCode) {
    return '`$text`';
  } else if (style == MarkdownStyles.unorderedList) {
    List listItems = text.split("\n");

    String formattedListText = '';

    for (var item in listItems) {
      formattedListText = "$formattedListText- $item\n";
    }

    return formattedListText;
  } else if (style == MarkdownStyles.orderedList) {
    List listItems = text.split("\n");

    String formattedListText = '';

    int i = 1;

    for (var item in listItems) {
      formattedListText = "$formattedListText$i. $item\n";

      i++;
    }

    return formattedListText;
  } else if (style == MarkdownStyles.checkList) {
    List listItems = text.split("\n");

    String formattedListText = '';

    for (var item in listItems) {
      formattedListText = "$formattedListText- [ ] $item\n";
    }

    return formattedListText;
  } else if (style == MarkdownStyles.image) {
    return '\n![]($text)\n';
  } else {
    return text;
  }
}
