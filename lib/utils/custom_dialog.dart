import 'package:flutter/material.dart';

class CustomDialog {
  CustomDialog({required this.context});

  final BuildContext context;

  Widget defaultTitle = Text("Tiêu đề");
  Widget defaultContent = Text("Nội dung");
  List<Widget> defaultAction = [
    TextButton(
      child: const Text('Xác nhận'),
      onPressed: () {},
    )
  ];

  setDefaultDialog(Widget title, Widget content, List<Widget> action) {
    defaultTitle = title;
    defaultContent = content;
    defaultAction = action;
  }

  Future<void> show(
      {Widget? titleWidget,
      Widget? contentWidget,
      List<Widget>? actionWidget}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: titleWidget ?? defaultTitle,
          content: contentWidget ?? defaultContent,
          actionsAlignment: MainAxisAlignment.center,
          actions: actionWidget ?? defaultAction,
        );
      },
    );
  }
}
