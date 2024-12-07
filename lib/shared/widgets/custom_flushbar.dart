

import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';

class CustomFlushbar {
  final String message;
  final String title;

  final Color color;

  CustomFlushbar({
    required this.message,
    required this.color,
    required this.title,

  });

  void show(BuildContext context) {
    Flushbar(
      title: title,
      message: message,
      backgroundColor: color,
      icon: Icon(
        color == Colors.green ? Icons.check_circle : Icons.error,
        color: Colors.white,
      ),
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(8.0),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    ).show(context);
  }
}

