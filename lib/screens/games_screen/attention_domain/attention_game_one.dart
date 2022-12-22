import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brain_training/utils/helper.dart';
import 'package:brain_training/constants/color.dart';
import 'package:brain_training/widget/clock.dart';

class AttentionGameOne extends StatefulWidget {
  const AttentionGameOne({super.key});

  @override
  State<AttentionGameOne> createState() => _AttentionGameOneState();
}

class _AttentionGameOneState extends State<AttentionGameOne> {
  String ATTENTION_GAME_1_PATH = "lib/constants/attention_game_1.json";
  String ATTENTION_KEY = "attentionData";

  late double screenHeight, screenWidth, boxHeight, boxWidth;

  List<String> imagesAssetPath = [];
  List<String> solutionAssetPath = [];
  List gameData = [];
  int currentQuestion = 0;
  late int currentKey;
  late double scaleRatio;

  int getCurrentDataIndex(String imageName) {
    String key = imageName.split("/").last.split(".").first;
    return int.parse(key) - 1;
  }

  Future<void> _initImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Load Path
    final solutionImagePath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Attention/'))
        .where((String key) => key.contains('Solution/'))
        .where((String key) => key.contains('28.png'))
        .toList();

    final attentionImagePath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Attention/'))
        .where((String key) => key.contains('Question/'))
        .where((String key) => key.contains('28.png'))
        .toList();
    attentionImagePath.shuffle();

    setState(() {
      solutionAssetPath = solutionImagePath;
      imagesAssetPath = attentionImagePath;
      currentKey = getCurrentDataIndex(imagesAssetPath[0]);
    });
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    int imageOriginalWidth = gameData[currentKey]["size"]["x"];
    int imageOriginalHeight = gameData[currentKey]["size"]["y"];

    double posX = details.localPosition.dx;
    double posY = details.localPosition.dy;

    // print("posX: $posX, posY: $posY");

    double resultX = boxWidth / 2 +
        gameData[currentKey]["result"]["x"] * imageOriginalWidth * scaleRatio;
    double resultY = boxHeight / 2 +
        gameData[currentKey]["result"]["y"] * imageOriginalHeight * scaleRatio;
    // print("resultX: $resultX, resultY: $resultY");

    double validWidthRange = 0.05 * boxWidth;
    double validHeightRange = 0.07 * boxHeight;
    // print(
    //     "validWidthRange: $validWidthRange, validHeightRange: $validHeightRange");

    if (posX >= resultX - validWidthRange &&
        posX <= resultX + validWidthRange &&
        posY >= resultY - validHeightRange &&
        posY <= resultY + validHeightRange) {
      print("Correct");
    } else {
      print("Wrong");
    }
    // print('Result: $resultX, $resultY');
  }

  double calculateImageScale(int key) {
    int imageOriginalWidth = gameData[key]["size"]["x"];
    int imageOriginalHeight = gameData[key]["size"]["y"];
    double widthRatio = imageOriginalWidth / boxWidth;
    double heightRatio = imageOriginalHeight / boxHeight;
    double result = 1.0;

    if (widthRatio > heightRatio && widthRatio > 1) {
      result = boxWidth / imageOriginalWidth;
    } else if (heightRatio > widthRatio && heightRatio > 1) {
      result = boxHeight / imageOriginalHeight;
    }

    return result;
  }

  @override
  void initState() {
    super.initState();

    _initImages();
    readJson(ATTENTION_GAME_1_PATH, ATTENTION_KEY).then((imageData) {
      gameData = imageData;
      scaleRatio = calculateImageScale(currentKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    boxHeight = screenHeight * 0.5;
    boxWidth = screenWidth;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Hãy tìm vị trí đúng theo yêu cầu"),
          backgroundColor: pinkPastel,
          titleTextStyle: const TextStyle(
            color: darkTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                "Điểm: 0",
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: primaryOrange,
                    fontSize: 35),
              ),
            ),
            Clock(seconds: 120),
            SizedBox(height: 30),
            Container(
                height: boxHeight,
                child: imagesAssetPath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                            child: GestureDetector(
                                onTapDown: (TapDownDetails details) =>
                                    onTapDown(context, details),
                                child: Ink.image(
                                  image: AssetImage(
                                      imagesAssetPath[currentQuestion]),
                                  fit: BoxFit.scaleDown,
                                  child: InkWell(
                                    onTap: () {},
                                  ),
                                ))))
                    : Container())
          ],
        ));
  }
}
