import 'package:flutter/material.dart';

///
extension Visible on Widget {
  ///
  Widget visibility({required bool isVisible}) {
    return Visibility(visible: isVisible, child: this);
  }
}
