/// this file contains extensions applies on the [StatelessWidget] Class
import 'package:flutter/material.dart';

extension StatelessScreenSize on StatelessWidget {
  /// screen size
  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}
