import 'package:brain_training/constants/color.dart';
import 'package:flutter/material.dart';

import '../../widget/grid_game.dart';

class MainMenu extends StatefulWidget {
  MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<String> listDomain = ["Trí nhớ", "Nhận thức", "Ngôn ngữ", "Toán học"];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Chọn lĩnh vực trò chơi",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              color: primaryOrange,
              fontWeight: FontWeight.w700,
            )),
        const SizedBox(
          height: 40,
        ),
        GridGame(
          listDomain: listDomain,
          context: context,
          typeView: 'playing',
        ),
      ],
    );
  }
}
