import 'package:flutter/material.dart';
import 'package:brain_training/constants/enum.dart';
import 'dart:io' show Platform;

class Toast {
  const Toast({required this.context});

  final BuildContext context;

  ScaffoldFeatureController show(String content, Color snackBarColor,
      {int snackBarDuration: 1500,
      ToastPosition position: ToastPosition.bottom}) {
    final scaffold = ScaffoldMessenger.of(context);
    return scaffold.showSnackBar(
      SnackBar(
          backgroundColor: snackBarColor,
          content: Text(content),
          duration: Duration(milliseconds: snackBarDuration),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: position == ToastPosition.top
              ? EdgeInsets.only(
                  bottom: Platform.isIOS
                      ? MediaQuery.of(context).size.height - 180
                      : MediaQuery.of(context).size.height - 120,
                  right: 20,
                  left: 20)
              : EdgeInsets.symmetric(horizontal: 20)),
    );
  }
}
