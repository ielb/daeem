/// this file contains all extensions applies on the [State] Class
import 'package:flutter/material.dart';

extension StateScreenSize on State {
  /// screen size
  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}
