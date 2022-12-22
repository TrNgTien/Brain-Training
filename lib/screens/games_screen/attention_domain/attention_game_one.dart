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
  int currentQuestion = 0; // order of question
  int point = 0;

  bool isCorrect = false;
  late int currentKey; // ID of question
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
  void nextQuestion() {}

  void endGame() {}

  // Image & Image Data
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

  // Game Logic
  void onTapDown(BuildContext context, TapDownDetails details) {
    int imageOriginalWidth = gameData[currentKey]["size"]["x"];
    int imageOriginalHeight = gameData[currentKey]["size"]["y"];

    double posX = details.localPosition.dx;
    double posY = details.localPosition.dy;

    double resultX = boxWidth / 2 +
        gameData[currentKey]["result"]["x"] * imageOriginalWidth * scaleRatio;
    double resultY = boxHeight / 2 +
        gameData[currentKey]["result"]["y"] * imageOriginalHeight * scaleRatio;

    double validWidthRange = 0.05 * boxWidth;
    double validHeightRange = 0.07 * boxHeight;

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

  // Main
  @override
  void initState() {
    super.initState();

    _initImages();
    readJson(ATTENTION_GAME_1_PATH, ATTENTION_KEY).then((imageData) {
      gameData = imageData;
      scaleRatio = calculateImageScale(currentKey);
    });
    startTotalTimer();
    startQuestionTimer();
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
                        gameData[currentKey]["title"],
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
                                    ? GestureDetector(
                                        onTapDown: (TapDownDetails details) =>
                                            onTapDown(context, details),
                                        child: Ink.image(
                                          image: AssetImage(
                                              imagesAssetPath[currentQuestion]),
                                          fit: BoxFit.scaleDown,
                                          child: InkWell(
                                            onTap: () {},
                                          ),
                                        ))
                                    : Ink.image(
                                        image: AssetImage(
                                            solutionAssetPath[currentQuestion]),
                                        fit: BoxFit.scaleDown,
                                      ))))
                  ])
                : Container(),
            SizedBox(height: 32),
            isCorrect
                ? ElevatedButton(
                    onPressed: () {},
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
