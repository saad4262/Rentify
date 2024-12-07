import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getHeight(BuildContext context, double height) {
    return MediaQuery.of(context).size.height * height;
  }

  static double getWidth(BuildContext context, double width) {
    return MediaQuery.of(context).size.width * width;
  }

}