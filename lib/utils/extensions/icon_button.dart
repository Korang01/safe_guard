import 'package:flutter/material.dart';

/// icon button extension on widget
extension ButtonIcon on Widget {
  /// wrap widget with icon button
  Widget iconButton({
    required void Function() onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return IconButton(padding: padding, onPressed: onTap, icon: this);
  }
}
