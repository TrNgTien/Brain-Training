import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brain_training/constants/enum.dart';
import 'package:brain_training/utils/helper.dart';
import 'package:brain_training/constants/color.dart';
import 'package:brain_training/widget/clock.dart';

class AttentionGameOne extends StatefulWidget {
  const AttentionGameOne({super.key});

  @override
  State<AttentionGameOne> createState() => _AttentionGameOneState();
}

class _AttentionGameOneState extends State<AttentionGameOne> {
  final int TOTAL_TIME_SECONDS = 120;
  final int QUESTION_TIME_SECONDS = 15;
  final String ATTENTION_GAME_1_PATH = "lib/constants/attention_game_1.json";
  final String ATTENTION_KEY = "attentionData";

  GameStatus status = GameStatus.playing;
  late double screenHeight, screenWidth, boxHeight, boxWidth;

  Timer? questionCountdownTimer;
  Duration questionDuration = const Duration();
  Timer? totalCountdownTimer;
  Duration totalDuration = const Duration();

  List<String> imagesAssetPath = [];
  List<String> solutionAssetPath = [];
  List gameData = [];
  late int currentKey; // ID of image key

  int currentQuestion = 0; // order of question
  int point = 0;

  bool isCorrect = false;
  late double scaleRatio;

  // Timer
  void startQuestionTimer() {
    questionDuration = Duration(seconds: QUESTION_TIME_SECONDS);
    questionCountdownTimer = Timer.periodic(
        const Duration(seconds: 1), (_) => setQuestionCountDown());
  }

  void startTotalTimer() {
    totalDuration = Duration(seconds: TOTAL_TIME_SECONDS);
    totalCountdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setTotalCountDown());
  }

  void setQuestionCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = questionDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        outOfQuestionTime();
      } else {
        questionDuration = Duration(seconds: seconds);
      }
    });
  }

  void setTotalCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = totalDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        setCancelTotalTimer();
      } else {
        totalDuration = Duration(seconds: seconds);
      }
    });
  }

  void setCancelQuestionTimer() {
    questionCountdownTimer!.cancel();
  }

  void setCancelTotalTimer() {
    totalCountdownTimer!.cancel();
  }

  // Timer Logic
  void outOfQuestionTime() {
    if (currentQuestion >= imagesAssetPath.length - 1) {
      endGame();
    } else {
      nextQuestion();
    }
  }

  // Question Logic
  void nextQuestion() {
    setState(() {
      isCorrect = false;
      currentQuestion++;
      currentKey = getCurrentKeyValue(imagesAssetPath[currentQuestion]);
    });
  }

  void endGame() {}

  // Image & Image Data
  int getCurrentKeyValue(String imageName) {
    String key = imageName.split("/").last.split(".").first;
    return int.parse(key);
  }

  Future<int> _initImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Load Path
    final solutionImagePath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Attention/'))
        .where((String key) => key.contains('Solution/'))
        .where((String key) => key.contains('.png'))
        .toList();

    final attentionImagePath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Attention/'))
        .where((String key) => key.contains('Question/'))
        .where((String key) => key.contains('.png'))
        .toList();
    attentionImagePath.shuffle();
    setState(() {
      solutionAssetPath = solutionImagePath;
      imagesAssetPath = attentionImagePath;
      currentKey = getCurrentKeyValue(imagesAssetPath[currentQuestion]);
    });
    return currentKey;
  }

  // Game Logic
  void onTapDown(BuildContext context, TapDownDetails details) {
    int imageOriginalWidth = gameData[currentKey - 1]["size"]["x"];
    int imageOriginalHeight = gameData[currentKey - 1]["size"]["y"];

    double posX = details.localPosition.dx;
    double posY = details.localPosition.dy;
    // print("posX: $posX, posY: $posY");

    double resultX = boxWidth / 2 +
        gameData[currentKey - 1]["result"]["x"] *
            imageOriginalWidth *
            scaleRatio;
    double resultY = boxHeight / 2 +
        gameData[currentKey - 1]["result"]["y"] *
            imageOriginalHeight *
            scaleRatio;
    // print("resultX: $resultX, resultY: $resultY");

    double validWidthRange = gameData[currentKey - 1]["valid_ratio"]["x"] *
        imageOriginalWidth *
        scaleRatio /
        2;
    double validHeightRange = gameData[currentKey - 1]["valid_ratio"]["y"] *
        imageOriginalHeight *
        scaleRatio /
        2;
    // print(
    //     "validWidthRange: $validWidthRange, validHeightRange: $validHeightRange");

    if (posX >= resultX - validWidthRange &&
        posX <= resultX + validWidthRange &&
        posY >= resultY - validHeightRange &&
        posY <= resultY + validHeightRange) {
      handleCorrectAnswer();
    }
  }

  void handleCorrectAnswer() {
    setCancelQuestionTimer();
    setState(() {
      isCorrect = true;
      point += 200;
    });
  }

  double calculateImageScale(int key) {
    int imageOriginalWidth = gameData[key - 1]["size"]["x"];
    int imageOriginalHeight = gameData[key - 1]["size"]["y"];
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

  // Main
  @override
  void initState() {
    super.initState();

    _initImages().then((value) {
      readJson(ATTENTION_GAME_1_PATH, ATTENTION_KEY).then((imageData) {
        gameData = imageData;
        scaleRatio = calculateImageScale(value);
        startTotalTimer();
        startQuestionTimer();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    setCancelQuestionTimer();
    setCancelTotalTimer();
  }

  @override
  Widget build(BuildContext context) {
    int seconds = questionDuration.inSeconds;
    int totalSeconds = totalDuration.inSeconds;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    boxHeight = screenHeight * 0.5;
    boxWidth = screenWidth;

    return Scaffold(
        appBar: AppBar(
          title: Text("Tổng thời gian còn lại: $totalSeconds"),
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
                "Điểm: $point",
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: primaryOrange,
                    fontSize: 35),
              ),
            ),
            Clock(seconds: seconds),
            SizedBox(height: 30),
            imagesAssetPath.isNotEmpty && gameData.isNotEmpty
                ? Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        gameData[currentKey - 1]["title"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: darkTextColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                        height: boxHeight,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Material(
                                child: !isCorrect
                                    ? Ink.image(
                                        image: AssetImage(
                                            imagesAssetPath[currentQuestion]),
                                        fit: BoxFit.scaleDown,
                                        child: InkWell(
                                            onTapDown: (TapDownDetails
                                                    details) =>
                                                onTapDown(context, details)),
                                      )
                                    : Ink.image(
                                        image: AssetImage(
                                            solutionAssetPath.firstWhere(
                                                (element) => element.contains(
                                                    currentKey.toString()))),
                                        fit: BoxFit.scaleDown,
                                      ))))
                  ])
                : Container(),
            SizedBox(height: 32),
            isCorrect && currentQuestion < imagesAssetPath.length - 1
                ? ElevatedButton(
                    onPressed: () => nextQuestion(),
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child:
                            Text("Tiếp theo", style: TextStyle(fontSize: 24))),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange))
                : Container()
          ],
        ));
  }
}
