import 'package:brain_training/main.dart';
import 'package:brain_training/screens/profile_screen/profile_screen.dart';
import 'package:brain_training/screens/ranking_screen/ranking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNav extends StatefulWidget {
  final Color? colorBackground;
  final Color? colorUnselectedItem;
  final Color? colorSelectedItem;
  BottomNav(
      {super.key,
      required this.colorBackground,
      required this.colorUnselectedItem,
      required this.colorSelectedItem});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  String playingIcon = "lib/assets/icons/playing_ic.svg";
  String profileIcon = "lib/assets/icons/profile_ic.svg";
  String rankingIcon = "lib/assets/icons/ranking_ic.svg";
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const MyHomePage(
                title: "Brain Training",
              ),
          fullscreenDialog: true));
    } else if (_selectedIndex == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => RankingScreen()));
    } else if (_selectedIndex == 2) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ProfileScreen()));
    }
  }

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
            color: _selectedIndex == 0
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
            color: _selectedIndex == 1
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
            color: _selectedIndex == 2
                ? widget.colorSelectedItem
                : widget.colorUnselectedItem,
          )),
          label: 'Cá nhân',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
