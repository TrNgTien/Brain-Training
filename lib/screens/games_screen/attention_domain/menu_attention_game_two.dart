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
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                children: difficulty.entries.map((entry) {
              switch (entry.key) {
                case GameDifficulty.EASY:
                  return difficultyButton(context, entry.key, entry.value);
                case GameDifficulty.MEDIUM:
                  return difficultyButton(context, entry.key, entry.value);
                case GameDifficulty.HARD:
                  return difficultyButton(context, entry.key, entry.value);
              }
            }).toList()),
          ),
        ));
  }

  Widget difficultyButton(
      BuildContext context, GameDifficulty dif, String tag) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttentionGame2(difficulty: dif),
            ),
          );
        },
        child: Text(tag.toString()));
  }
}
