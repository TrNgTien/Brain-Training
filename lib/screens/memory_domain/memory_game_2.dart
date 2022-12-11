import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:brain_training/constants/color.dart';
import 'package:stack/stack.dart' as StackDS;

class MemoryGame2 extends StatefulWidget {
  const MemoryGame2({Key? key}) : super(key: key);

  @override
  State<MemoryGame2> createState() => _MemoryGame2State();
}

class _MemoryGame2State extends State<MemoryGame2> {
  final int MAX_ROUNDS = 3; // Number of rounds for a game session
  final int STARTING_CARDS = 3; // Number of cards when starting a game session
  final random = Random();

  StackDS.Stack<List<String>> _stackRounds = StackDS.Stack();
  List<String> list = []; // Total card list in 1 round
  List<String> initCards = []; // Rendered cards for user to play
  List<String> selectedCards = [""]; // User's selection

  int point = 0;
  int round = 1;

  Future<List<List<String>>> _loadImagesPath() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    List<List<String>> imagesAssetPath = [];

    final animalImagesPath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Animal/'))
        .toList();
    imagesAssetPath.add(animalImagesPath);

    final transportationImagesPath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Transportation/'))
        .toList();
    imagesAssetPath.add(transportationImagesPath);

    final fruitVegetableImagesPath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('FruitVegetable/'))
        .toList();
    imagesAssetPath.add(fruitVegetableImagesPath);

    final householdItemImagesPath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('HouseholdItem/'))
        .toList();
    imagesAssetPath.add(householdItemImagesPath);

    return imagesAssetPath;
  }

  Future _initImages() async {
    final imagesAssetPath = await _loadImagesPath();
    // From the assets, get random MAX_ROUNDS sources for a game
    final imagesForThisGame = imagesAssetPath.sample(MAX_ROUNDS);

    for (int i = 0; i < MAX_ROUNDS; i++) {
      _stackRounds.push(imagesForThisGame[i]);
    }

    setState(() {
      list = _stackRounds.pop();
      initCards = list.sample(STARTING_CARDS);
    });
  }

  @override
  void initState() {
    super.initState();
    _initImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Màn " + round.toString()),
          backgroundColor: greenPastel,
          foregroundColor: darkTextColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(children: [
                    Text(
                      "Điểm: $point",
                      style: TextStyle(
                          color: primaryOrange,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Hãy chọn 1 hình ảnh mà bạn muốn ghi nhớ để bắt đầu trò chơi",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          // color: primaryOrange,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    )
                  ])),
              initCards.isNotEmpty
                  ? GridView.count(
                      crossAxisCount: STARTING_CARDS,
                      shrinkWrap: true,
                      children: initCards
                          .map((e) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                  decoration: selectedCards.last == e
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border:
                                              Border.all(color: primaryOrange),
                                          boxShadow: [
                                            BoxShadow(
                                              color: orangePastel,
                                              blurRadius: 5.0,
                                              offset: Offset(0, 10),
                                              spreadRadius: 0.5,
                                            ),
                                          ],
                                        )
                                      : null,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Material(
                                          child: Ink.image(
                                              fit: BoxFit.scaleDown,
                                              image: AssetImage(e),
                                              child: InkWell(
                                                onTap: () {
                                                  print(selectedCards);
                                                  setState(() {
                                                    selectedCards.removeLast();
                                                    selectedCards.add(e);
                                                  });
                                                },
                                              )))))))
                          .toList(),
                    )
                  : Container(),
              const SizedBox(height: 60),
              ElevatedButton(
                  onPressed: () {},
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Bắt đầu", style: TextStyle(fontSize: 24))),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primaryOrange))
            ],
          ),
        ));
  }
}
