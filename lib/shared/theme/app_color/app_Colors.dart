import 'package:flutter/material.dart';

class AppColors{
  static const Color whiteColor= Colors.white;
  static const Color black= Color.fromRGBO(0, 0, 0, 0.5);
  static const Color lightBlack = Color.fromRGBO(0, 0, 0, 0.3);
  static const Color lightWhiteColor = Colors.white54;
  static const Color blueColor=Color(0xFF0000FF);
  static const Color buttonTextColor = Color(0xFFde4c59);
  static const Color darkRedColor= Color(0xFFA0331E);
  static const Color btnColor= Color(0xFF8BC83F);

  static const LinearGradient myGradient = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [0.0527, 0.4603, 0.9115],
      colors: [
      Color(0xFFFF6423),
      Color(0xFFF24843),
      Color(0xFFE42967),
      ],

  );

}
