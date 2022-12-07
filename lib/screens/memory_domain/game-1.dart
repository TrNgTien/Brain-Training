import 'package:brain_training/widget/grid_builder.dart';
import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';

class Game1 extends StatefulWidget {
  const Game1({super.key});

  @override
  State<Game1> createState() => _Game1State();
}

class _Game1State extends State<Game1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBackground,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          child: Column(
            children: [
              Text("Điểm"),
              Text("Thời gian"),
            ],
          ),
        ),
        GridBuilder(
          numberItems: 100,
          matrix: 10,
        )
      ]),
    );
  }
}
