import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';
import 'package:flutter_svg/svg.dart';
import "package:brain_training/constants/icons.dart";

class Clock extends StatelessWidget {
  final int seconds;
  Clock({super.key, required this.seconds});

  Widget clockTimer(int seconds) {
    if (seconds <= 2) {
      return Text(
        '00:${seconds <= 9 ? '0$seconds' : '$seconds'}',
        style: const TextStyle(
            fontWeight: FontWeight.w700, color: Colors.red, fontSize: 20),
      );
    } else {
      return Text(
        '00:${seconds <= 9 ? '0$seconds' : '$seconds'}',
        style: const TextStyle(
            fontWeight: FontWeight.w700, color: darkTextColor, fontSize: 20),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          clockIcon,
          height: 35,
          width: 35,
          color: seconds <= 2 ? Colors.red : darkTextColor,
        ),
        const SizedBox(
          width: 5,
        ),
        clockTimer(seconds)
      ],
    );
  }
}
