/// this file contains extensions on the [Widget] Class
import 'package:flutter/material.dart';

extension PaddingsExtensions on Widget {
  /// wraps the widget within and Expanded widget
  Widget expandIt({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  /// adds padding from all sides to a widget
  Widget paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  /// make it flexible
  Widget makeItFlexible({int flex = 1}) {
    return Flexible(
      child: this,
      flex: flex,
    );
  }

  /// adds padding only from some sides to a widget
  Widget paddingOnly({
    double top = 0,
    double bottom = 0,
    double left = 0,
    double right = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ),
      child: this,
    );
  }

  /// adds symmetric padding to a widget
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }

  /// align
  Widget align({required Alignment alignment}) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  /// centers a widget
  Widget center() {
    return Center(
      child: this,
    );
  }
}
