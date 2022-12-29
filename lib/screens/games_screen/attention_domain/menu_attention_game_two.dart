import 'package:brain_training/constants/color.dart';
import 'package:brain_training/screens/games_screen/attention_domain/attention_game_two.dart';
import 'package:brain_training/screens/games_screen/attention_domain/enum.dart';
import 'package:flutter/material.dart';

class AttentionGame2Menu extends StatefulWidget {
  AttentionGame2Menu({Key? key}) : super(key: key);

  @override
  State<AttentionGame2Menu> createState() => _AttentionGame2MenuState();
}

class _AttentionGame2MenuState extends State<AttentionGame2Menu> {
  Map<GameDifficulty, String> difficulty = {
    GameDifficulty.EASY: 'Dễ',
    GameDifficulty.MEDIUM: 'Trung bình',
    GameDifficulty.HARD: 'Khó'
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: yellowPastel,
          foregroundColor: darkTextColor,
          centerTitle: true,
          title: Text(
            "Chọn độ khó",
            style: TextStyle(color: darkTextColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: difficulty.entries.map((entry) {
                    switch (entry.key) {
                      case GameDifficulty.EASY:
                        return difficultyButton(
                            context, entry.key, entry.value, greenBtn);
                      case GameDifficulty.MEDIUM:
                        return difficultyButton(
                            context, entry.key, entry.value, yellowBtn);
                      case GameDifficulty.HARD:
                        return difficultyButton(
                            context, entry.key, entry.value, pinkBtn);
                    }
                  }).toList()),
            ),
          ),
        ));
  }

  Widget difficultyButton(
      BuildContext context, GameDifficulty dif, String tag, Color color) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: color, fixedSize: Size.fromHeight(70)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AttentionGame2(difficulty: dif),
              ),
            );
          },
          child: Text(
            tag.toString(),
            style: TextStyle(
              fontSize: 25,
              color: darkTextColor,
            ),
          ),
        ));
  }
}
