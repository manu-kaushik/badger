import 'package:badger/utils/enums.dart';
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

String getTrimmedContent(String body, {int length = 48}) {
  if (body.length > length) {
    return '${body.substring(0, length)}...';
  } else {
    return body;
  }
}
