import 'package:flutter/material.dart';

class Toast {
  const Toast({required this.context});

  final BuildContext context;

  ScaffoldFeatureController show(
      String content, Color snackBarColor, int snackBarDuration) {
    final scaffold = ScaffoldMessenger.of(context);
    return scaffold.showSnackBar(
      SnackBar(
        backgroundColor: snackBarColor,
        content: Text(content),
        width: 280.0, // Width of the SnackBar.
        duration: Duration(milliseconds: snackBarDuration),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
