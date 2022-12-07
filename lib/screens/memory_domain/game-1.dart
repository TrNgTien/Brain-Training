import 'package:brain_training/widget/grid_builder.dart';
import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';
import 'package:flutter_svg/svg.dart';

class Game1 extends StatefulWidget {
  const Game1({super.key});

  @override
  State<Game1> createState() => _Game1State();
}

class _Game1State extends State<Game1> {
  int score = 0;
  String clockIcon = "lib/assets/icons/clock_ic.svg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Chọn ô màu"),
        backgroundColor: greenPastel,
        foregroundColor: darkTextColor,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          child: Column(
            children: [
              Text(
                "Điểm: $score",
                style: TextStyle(
                    color: primaryOrange,
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    clockIcon,
                    height: 30,
                    width: 30,
                  ),
                  Text("Thời gian"),
                ],
              )
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
