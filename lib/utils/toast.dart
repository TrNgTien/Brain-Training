import 'package:flutter/material.dart';

class Toast {
  const Toast({required this.context});

  final BuildContext context;

  ScaffoldFeatureController show(String content, Color snackBarColor,
      {int snackBarDuration: 1500,
      EdgeInsets margin: const EdgeInsets.symmetric(horizontal: 20)}) {
    final scaffold = ScaffoldMessenger.of(context);
    return scaffold.showSnackBar(SnackBar(
        backgroundColor: snackBarColor,
        content: Text(content),
        duration: Duration(milliseconds: snackBarDuration),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: margin));
  }
}
