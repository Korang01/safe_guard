import 'package:flutter/material.dart';

///
extension SizedSpacer on Widget {
  ///
  Widget safeArea({
    EdgeInsets minimum = EdgeInsets.zero,
    bool maintainBottomViewPadding = false,
    bool left = true,
    bool top = true,
    bool right = true,
    bool bottom = true,
  }) {
    return SafeArea(
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: this,
    );
  }

  ///
  Widget sizedBox({double? vertical, double? horizontal}) => SizedBox(
        height: vertical,
        width: horizontal,
      );
}
