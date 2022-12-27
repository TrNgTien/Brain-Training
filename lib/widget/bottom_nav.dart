import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:brain_training/constants/icons.dart";

class BottomNav extends StatefulWidget {
  final Color? colorBackground;
  final Color? colorUnselectedItem;
  final Color? colorSelectedItem;
  final Function(int)? function;
  final int selectedIndex;
  BottomNav(
      {super.key,
      required this.colorBackground,
      required this.colorUnselectedItem,
      required this.colorSelectedItem,
      required this.function,
      required this.selectedIndex});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: widget.colorBackground,
      unselectedItemColor: widget.colorUnselectedItem,
      selectedItemColor: widget.colorSelectedItem,
      selectedFontSize: 16,
      unselectedFontSize: 13,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Container(
              child: SvgPicture.asset(
            playingIcon,
            height: 30,
            width: 30,
            color: widget.selectedIndex == 0
                ? widget.colorSelectedItem
                : widget.colorUnselectedItem,
          )),
          label: 'Tập luyện',
        ),
        BottomNavigationBarItem(
          icon: Container(
              child: SvgPicture.asset(
            rankingIcon,
            height: 30,
            width: 30,
            color: widget.selectedIndex == 1
                ? widget.colorSelectedItem
                : widget.colorUnselectedItem,
          )),
          label: 'Xếp hạng',
        ),
        BottomNavigationBarItem(
          icon: Container(
              child: SvgPicture.asset(
            profileIcon,
            height: 30,
            width: 30,
            color: widget.colorBackground == 2
                ? widget.colorSelectedItem
                : widget.colorUnselectedItem,
          )),
          label: 'Cá nhân',
        ),
      ],
      currentIndex: widget.selectedIndex,
      onTap: (int index) => widget.function!(index),
    );
  }
}
