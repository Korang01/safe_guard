import 'package:flutter/cupertino.dart';

/// A extension that dismisses focus from child

extension DismissFocus on Widget {
  /// widget function that dismisses the focus
  Widget dismissFocus() {
    return GestureDetector(
      onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: this,
    );
  }
}

/// Column Extension
extension LayoutsWithChildrenExtension on List<Widget> {}
