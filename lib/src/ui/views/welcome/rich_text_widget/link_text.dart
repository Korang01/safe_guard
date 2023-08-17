import 'package:flutter/foundation.dart' show VoidCallback, immutable;

import 'base_text.dart';

@immutable

/// class to define custom text
class CustomText extends BaseText {
  /// custom text constructor
  const CustomText({required super.text, this.onTapped, super.style});

  /// void function to define actions when tapped
  final VoidCallback? onTapped;
}
