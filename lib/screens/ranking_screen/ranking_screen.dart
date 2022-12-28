import 'package:brain_training/widget/grid_game.dart';
import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> listDomain = ["Trí nhớ", "Nhận thức", "Ngôn ngữ", "Toán học"];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Chọn loại xếp hạng",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: primaryOrange,
                fontWeight: FontWeight.w700,
              )),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: GridGame(
                listDomain: listDomain, context: context, typeView: 'ranking'),
          ),
        ],
      ),
    );
  }
}
