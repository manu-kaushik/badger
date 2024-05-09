import 'package:badger/utils/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

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

String formatDateToTimeAgo(String dateString) {
  try {
    if (RegExp(r"\d{1,2} \w+, \d{4} \d{1,2}:\d{2} [AP]M")
        .hasMatch(dateString)) {
      DateFormat dateFormat = DateFormat("d MMMM, yyyy hh:mm a");

      DateTime dateTime = dateFormat.parse(dateString);

      return timeago.format(dateTime);
    } else {
      DateTime dateTime = DateTime.parse(dateString);

      return timeago.format(dateTime);
    }
  } catch (e) {
    return "";
  }
}

String getTrimmedContent(
  String body, {
  int length = 48,
  TrimTypes type = TrimTypes.line,
}) {
  if (type == TrimTypes.line) {
    return body.split('\n').first;
  }

  if (body.length > length) {
    return '${body.substring(0, length)}...';
  }

  return body;
}

MarkdownStyleSheet getMarkdownStyleSheet(BuildContext context) {
  return MarkdownStyleSheet(
    blockSpacing: 16.0,
    code: TextStyle(
      fontFamily: 'SourceCodePro',
      fontWeight: FontWeight.w500,
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade300
          : Colors.grey.shade800,
    ),
    codeblockDecoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade300
          : Colors.grey.shade800,
      borderRadius: BorderRadius.circular(8.0),
    ),
    codeblockPadding: const EdgeInsets.symmetric(
      vertical: 12.0,
      horizontal: 16.0,
    ),
    blockquoteDecoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.light
          ? primaryColor.shade50
          : primaryColor.shade900,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4.0),
        topRight: Radius.circular(8.0),
        bottomLeft: Radius.circular(4.0),
        bottomRight: Radius.circular(8.0),
      ),
      border: Border(
        left: BorderSide(
          color: Theme.of(context).brightness == Brightness.light
              ? primaryColor.shade200
              : primaryColor.shade400,
          width: 8.0,
        ),
      ),
    ),
    blockquotePadding: const EdgeInsets.symmetric(
      vertical: 12.0,
      horizontal: 16.0,
    ),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey.shade400
              : Colors.grey.shade700,
        ),
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}
