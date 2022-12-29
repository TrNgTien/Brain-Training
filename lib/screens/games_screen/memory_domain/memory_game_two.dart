import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:brain_training/constants/color.dart';
import 'package:stack/stack.dart' as StackDS;
import 'package:brain_training/utils/toast.dart';
import 'package:brain_training/utils/custom_dialog.dart';

class MemoryGameTwo extends StatefulWidget {
  const MemoryGameTwo({Key? key}) : super(key: key);

  @override
  State<MemoryGameTwo> createState() => _MemoryGameTwoState();
}

class _MemoryGameTwoState extends State<MemoryGameTwo> {
  final int MAX_TRIALS = 3; // Number of trials for a game session
  final int STARTING_CARDS = 3; // Number of cards when starting a game session
  List<List<String>> imagesAssetPath = [];

  StackDS.Stack<List<String>> _stackRounds = StackDS.Stack();
  List<String> list = []; // Total card list in 1 trial
  List<String> initCards = []; // Rendered cards for user to play
  List<String> selectedCards = [""]; // User's selection

  int point = 0;
  int trial = 1;
  int level = 0;
  bool endGame = false;

  bool _needScroll = false;
  ScrollController _scrollController = ScrollController();

  late Toast toast;
  late CustomDialog dialog;

  Future<void> _loadImages() async {
    await _loadAssetsFiles();
    _initImages();
  }

  Future<void> _loadAssetsFiles() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Image handler
    final animalImagesPath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Animal/'))
        .toList();

    final transportationImagesPath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Transportation/'))
        .toList();

    final fruitVegetableImagesPath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('FruitVegetable/'))
        .toList();

    final householdItemImagesPath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('HouseholdItem/'))
        .toList();

    imagesAssetPath.addAll([
      animalImagesPath,
      transportationImagesPath,
      fruitVegetableImagesPath,
      householdItemImagesPath,
    ]);
  }

  void _initImages() {
    // From the assets, get random MAX_TRIALS sources for a game
    final imagesForThisGame = imagesAssetPath.sample(MAX_TRIALS);

    for (int i = 0; i < MAX_TRIALS; i++) {
      _stackRounds.push(imagesForThisGame[i]);
    }

    setupGameCards();
  }

  void setupGameCards() {
    setState(() {
      selectedCards = [""]; // Reset selected cards
      list = _stackRounds.pop();
      initCards = list.sample(STARTING_CARDS);
      list.removeWhere((card) => initCards.contains(card));
    });
  }

  // Logic handler
  void handleButtonPress() {
    if (endGame) {
      // Play again
      restartGame();
    } else if (selectedCards.length == 1) {
      // Start trial
      setState(() {
        selectedCards.add("");
      });

      nextLevel();
    } else {
      // Check result
      checkUserAnswer();
    }
  }

  void restartGame() {
    // Reset all game data
    setState(() {
      point = 0;
      trial = 1;
      level = 0;
      endGame = false;
    });
    // Initialize new game images
    _initImages();
  }

  void checkUserAnswer() {
    String userSelectedCards = selectedCards.removeLast();
    if (!selectedCards.contains(userSelectedCards)) {
      handleCorrectAnswer(userSelectedCards);
    } else {
      handleWrongAnswer();
    }
  }

  void handleCorrectAnswer(String userSelectedCards) {
    toast.show("Chính xác!", Colors.green, snackBarDuration: 1000);
    setState(() {
      selectedCards.addAll([userSelectedCards, ""]);
      point += 500;
    });
    nextLevel();
  }

  void handleWrongAnswer() {
    toast.show("Sai rồi! Chơi lại nhé", Colors.red, snackBarDuration: 1000);
    calculateBonusPoints();
    if (trial >= MAX_TRIALS) {
      setState(() {
        selectedCards = [""]; // Reset selected cards
        endGame = true;
      });

      dialog.show(Text("kết thúc"), Text("Tổng điểm: $point"), [
        TextButton(
            child: const Text('Xác nhận'),
            onPressed: () => Navigator.of(context).pop())
      ]);
      return;
    }
    nextTrial();
  }

  void calculateBonusPoints() {
    int weight = 100 * trial;

    setState(() {
      point += ((selectedCards.length - 1) * weight);
    });
  }

  void nextLevel() {
    String newCard = list.sample(1).first;
    setState(() {
      level++;

      // Remove this card from the list
      list.remove(newCard);
      // Add 1 random card
      initCards.add(newCard);
      // Shuffle the initCards for new turn
      initCards.shuffle();
    });
    _needScroll = true;
  }

  void _scrollToEnd() {
    // Auto scroll to the end of the list
    if (_scrollController.hasClients) {
      final position = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        position,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeOut,
      );
    }
  }

  void nextTrial() {
    setupGameCards();

    setState(() {
      level = 0;
      trial++;
    });
  }

  @override
  void initState() {
    super.initState();

    // Setup for dialog and toast
    toast = Toast(context: context);
    dialog = CustomDialog(context: context);

    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    if (_needScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
      _needScroll = false;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Lần chơi " + trial.toString()),
          centerTitle: true,
          backgroundColor: greenPastel,
          foregroundColor: darkTextColor,
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
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
                      selectedCards.length == 1 && !endGame
                          ? "Hãy chọn 1 hình ảnh mà bạn muốn ghi nhớ để bắt đầu lần chơi"
                          : "Hãy chọn những hình ảnh mà bạn chưa chọn trước đó",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          // color: primaryOrange,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    )
                  ])),
              initCards.isNotEmpty
                  ? GridView.count(
                      primary: false,
                      crossAxisCount: STARTING_CARDS,
                      shrinkWrap: true,
                      children: initCards
                          .map((e) => Padding(
                              padding: EdgeInsets.all(10.0),
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
                                                onTap: !endGame
                                                    ? () {
                                                        setState(() {
                                                          selectedCards
                                                              .removeLast();
                                                          selectedCards.add(e);
                                                        });
                                                      }
                                                    : null,
                                              )))))))
                          .toList(),
                    )
                  : Container(),
              // const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: selectedCards.last == "" && !endGame
                      ? null
                      : handleButtonPress,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          selectedCards.length == 1
                              ? !endGame
                                  ? "Bắt đầu"
                                  : "Chơi lại"
                              : "Kiểm tra",
                          style: TextStyle(fontSize: 24))),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primaryOrange)),
              const SizedBox(height: 100),
            ],
          ),
        ));
  }
}
