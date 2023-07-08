const String appName = 'Badger';

// Route Names
const String homeRoute = '/home';
const String manageNoteRoute = '/manage_note';

enum ManagementModes { add, view, edit }

enum Orders { asc, desc }

enum AlertTypes { info, success, warn, error }

enum MarkdownStyles {
  bold,
  italic,
  strikeThrough,
  blockQuote,
  divider,
  code,
  inlineCode,
  unorderedList,
  orderedList,
  checkList,
  image
}
