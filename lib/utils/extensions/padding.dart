import 'package:flutter/material.dart';

/// padding extension on widgets
extension Pad on Widget {
  /// padding from left top right bottom
  Widget paddingLTRB(double left, double top, double right, double bottom) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: this,
    );
  }

  /// symmetric padding on child
  Widget paddingSymmetric({double? horizontal, double? vertical}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      ),
      child: this,
    );
  }

  /// padding from left top right bottom
  Widget paddingOnly({double? left, double? top, double? right, double? bottom}) {
    return Padding(
      padding: EdgeInsets.only(
        left: left ?? 0,
        top: top ?? 0,
        right: right ?? 0,
        bottom: bottom ?? 0,
      ),
      child: this,
    );
  }

  /// padding from left top right bottom
  Widget sliverPaddingLTRB(double left, double top, double right, double bottom) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      sliver: this,
    );
  }

  /// symmetric padding on child
  Widget sliverPaddingSymmetric({double? horizontal, double? vertical}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      ),
      sliver: this,
    );
  }

  /// padding from left top right bottom
  Widget sliverPaddingOnly({double? left, double? top, double? right, double? bottom}) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: left ?? 0,
        top: top ?? 0,
        right: right ?? 0,
        bottom: bottom ?? 0,
      ),
      sliver: this,
    );
  }
}
