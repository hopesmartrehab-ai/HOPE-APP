import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

class HtmlHelper {
  /// Parses an HTML string safely.
  /// If it's valid HTML → returns parsed plain text
  /// If it's not HTML → returns the original string
  static String parseIfHtml(String input) {
    try {
      // Try parsing the string
      final Document document = html_parser.parse(input);

      // If parsing found <html> or <body> tags, assume it's HTML
      if (document.body != null &&
          document.body!.text.trim().isNotEmpty &&
          document.outerHtml != input) {
        return document.body!.text; // Extract plain text
      }

      // Otherwise return original
      return input;
    } catch (e) {
      // In case parsing fails, return original
      return input;
    }
  }
}
