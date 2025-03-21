
import 'package:flutter/material.dart';


class CustomSnackBar {

static void _showCustomSnackBar(
  BuildContext context,
  String message,
  Color backgroundColor,
) {
  ScaffoldMessenger.of(context).showSnackBar(

    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
    ),
  );
}

static void showSnackBarSafely(
  BuildContext context,
  String message,
  Color backgroundColor,
) {
  if (context.mounted) {
    _showCustomSnackBar(context, message, backgroundColor);
  }
}
  
}

