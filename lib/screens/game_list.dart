import 'package:brain_training/screens/math_domain/game_2.dart';
import 'package:brain_training/screens/math_domain/math_game_one.dart';
import 'package:brain_training/screens/memory_domain/game-1.dart';
import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';
import 'package:flutter/scheduler.dart';
import 'language_domain/language_game_one.dart';
import 'language_domain/language_game_four.dart';
import 'language_domain/language_game_three.dart';

class GameList extends StatefulWidget {
  String domainName;
  GameList({super.key, required this.domainName});

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  Color? backgroundColor(String domainType) {
    switch (domainType) {
      case "Trí nhớ":
        return greenPastel;
      case "Nhận thức":
        return pinkPastel;
      case "Toán học":
        return orangePastel;
      case "Ngôn ngữ":
        return yellowPastel;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.domainName),
          foregroundColor: darkTextColor,
          titleTextStyle: const TextStyle(
            color: darkTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          backgroundColor: backgroundColor(widget.domainName),
        ),
        body: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 100, top: 50),
                child: Text("Chọn trò chơi",
                    style: TextStyle(
                      fontSize: 40,
                      color: primaryOrange,
                      fontWeight: FontWeight.w700,
                    )),
              ),
              gameType(widget.domainName, context),
            ],
          ),
        ));
  }

  Widget gameType(String gameType, BuildContext context) {
    switch (gameType) {
      case "Toán học":
        return mathList(context);
      case "Ngôn ngữ":
        return languageList(context);
      case "Trí nhớ":
        return memoryList(context);
      case "Nhận thức":
        return attentionList(context);
      default:
        return Container();
    }
  }

  Widget languageList(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: darkTextColor,
              backgroundColor: greenBtn,
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const LanguageGameOne()));
            },
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Tìm từ hợp lệ"),
            )),
        const SizedBox(height: 50),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: darkTextColor,
              backgroundColor: pinkBtn,
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const LanguageGameThree()));
            },
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Nối từ thích hợp"),
            )),
        const SizedBox(height: 50),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: darkTextColor,
              backgroundColor: yellowBtn,
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const LanguageGameFour()));
            },
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Sắp xếp chữ cái",
              ),
            )),
      ],
    );
  }

  Widget mathList(BuildContext context) {
    return Center(
        child: Column(
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: darkTextColor,
              backgroundColor: greenBtn,
              textStyle: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const MathGame()));
            },
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Tìm số nhỏ hơn",
              ),
            )),
        const SizedBox(height: 50),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: darkTextColor,
              backgroundColor: yellowBtn,
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const Game2()));
            },
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Tìm tổng 2 số",
              ),
            )),
      ],
    ));
  }

  Widget memoryList(BuildContext context) {
    return Center(
        child: Column(
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: darkTextColor,
              backgroundColor: greenBtn,
              textStyle: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const Game1()));
            },
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "mem 1",
              ),
            )),
        const SizedBox(height: 50),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: darkTextColor,
              backgroundColor: yellowBtn,
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "mem 2",
              ),
            )),
        const SizedBox(height: 50),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: darkTextColor,
              backgroundColor: orangePastel,
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "mem 3",
              ),
            )),
        const SizedBox(height: 50),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: darkTextColor,
              backgroundColor: pinkBtn,
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "mem 4",
              ),
            )),
      ],
    ));
  }

  Widget attentionList(BuildContext context) {
    return Center(
        child: Column(
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: darkTextColor,
              backgroundColor: greenBtn,
              textStyle: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "attentionList 1",
              ),
            )),
        const SizedBox(height: 50),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: darkTextColor,
              backgroundColor: yellowBtn,
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "attentionList 2",
              ),
            )),
      ],
    ));
  }
}
