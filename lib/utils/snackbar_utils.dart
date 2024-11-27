import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message,
    {Color? backgroundColor, Color? textColor}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
      backgroundColor: backgroundColor,
    ),
  );
}
