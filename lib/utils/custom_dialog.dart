import 'package:flutter/material.dart';

class CustomDialog {
  CustomDialog({required this.context});

  final BuildContext context;

  Future<void> show(
      Widget titleWidget, Widget contentWidget, List<Widget> actionWidget) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: titleWidget,
          content: contentWidget,
          actionsAlignment: MainAxisAlignment.center,
          actions: actionWidget,
        );
      },
    );
  }
}
