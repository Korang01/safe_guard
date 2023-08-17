import 'package:flutter/foundation.dart' show VoidCallback, immutable;
import 'package:flutter/material.dart' show TextStyle;

import 'link_text.dart';

@immutable

/// Base text for rich text widget
class BaseText {
  /// base text constructor
  const BaseText({
    required this.text,
    this.style,
  });

  /// default plain text in rich text widget
  factory BaseText.plain({required String text, TextStyle? style}) =>
      BaseText(text: text, style: style);

  /// custom text in rich text widget
  factory BaseText.custom({required String text, VoidCallback? onTapped, TextStyle? style}) {
    return CustomText(text: text, onTapped: onTapped, style: style);
  }

  /// text within segregation
  final String text;

  /// text style
  final TextStyle? style;
}
