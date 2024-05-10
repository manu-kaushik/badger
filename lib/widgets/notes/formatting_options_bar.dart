import 'package:badger/utils/exports.dart';
import 'package:flutter/material.dart';

class FormattingOptionsBar extends StatefulWidget {
  final TextEditingController bodyController;

  const FormattingOptionsBar({
    super.key,
    required this.bodyController,
  });

  @override
  State<FormattingOptionsBar> createState() => _FormattingOptionsBarState();
}

class _FormattingOptionsBarState extends State<FormattingOptionsBar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              formatAndUpdateBody(MarkdownStyles.bold);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.shade100
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.format_bold_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              formatAndUpdateBody(MarkdownStyles.italic);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.shade100
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.format_italic_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              formatAndUpdateBody(MarkdownStyles.strikeThrough);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.shade100
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.format_strikethrough_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              formatAndUpdateBody(MarkdownStyles.blockQuote);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.shade100
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.format_quote_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              formatAndUpdateBody(MarkdownStyles.divider);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.shade100
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Text(
                '---',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              formatAndUpdateBody(MarkdownStyles.inlineCode);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.shade100
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.code_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              formatAndUpdateBody(MarkdownStyles.code);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.shade100
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? primaryColor
                                  : Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Icon(
                        Icons.code_rounded,
                        size: 16.0,
                        color: Theme.of(context).brightness == Brightness.light
                            ? primaryColor
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              formatAndUpdateBody(MarkdownStyles.unorderedList);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.shade100
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.format_list_bulleted_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              formatAndUpdateBody(MarkdownStyles.orderedList);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.shade100
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.format_list_numbered_outlined,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              formatAndUpdateBody(MarkdownStyles.checkList);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.shade100
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.checklist_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              formatAndUpdateBody(MarkdownStyles.image);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor.shade100
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.image,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void formatAndUpdateBody(MarkdownStyles style) {
    String originalText = widget.bodyController.text;
    TextSelection selection = widget.bodyController.selection;

    if (selection.textInside(originalText).isNotEmpty) {
      String selectedText = selection.textInside(originalText);

      int start = selection.start;
      int end = selection.end;

      String formattedText = textToMarkdown(style, selectedText);

      String updatedBody = originalText.replaceRange(start, end, formattedText);

      widget.bodyController.text = updatedBody;

      TextSelection newSelection = TextSelection.collapsed(offset: end);

      widget.bodyController.selection = newSelection;
    }
  }
}
