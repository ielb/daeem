/// this file contains extensions applies on the [StatefulWidget] Class
import 'package:flutter/material.dart';

extension StatefulScreenSize on StatefulWidget {
  /// screen size
  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}