import 'package:flutter/material.dart';

///
extension WidgetAlignment on Widget {
  ///
  Widget centerAlign() => Align(
        child: this,
      );

  ///
  Widget centerLeftAlign() => Align(
        alignment: Alignment.centerLeft,
        child: this,
      );

  ///
  Widget centerRightAlign() => Align(
        alignment: Alignment.centerRight,
        child: this,
      );

  ///
  Widget topCenterAlign() => Align(
        alignment: Alignment.topCenter,
        child: this,
      );

  ///
  Widget topLeftAlign() => Align(
        alignment: Alignment.topLeft,
        child: this,
      );

  ///
  Widget topRightAlign() => Align(
        alignment: Alignment.topRight,
        child: this,
      );

  ///
  Widget bottomCenterAlign() => Align(
        alignment: Alignment.bottomCenter,
        child: this,
      );

  ///
  Widget bottomLeftAlign() => Align(
        alignment: Alignment.bottomLeft,
        child: this,
      );

  ///
  Widget bottomRightAlign() => Align(
        alignment: Alignment.bottomRight,
        child: this,
      );

  ///
  Widget expanded({int? flex}) => Expanded(
        flex: flex ?? 1,
        child: this,
      );
}
