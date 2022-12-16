import 'dart:async';
import 'dart:convert';
import 'package:brain_training/screens/games_screen/attention_domain/enum.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AttentionGame2 extends StatefulWidget {
  AttentionGame2({Key? key, required this.difficulty}) : super(key: key);
  final GameDifficulty difficulty;
  @override
  State<AttentionGame2> createState() => _AttentionGame2State();
}

class _AttentionGame2State extends State<AttentionGame2> {
  List<String> getList(int n, List<String> listSource) => listSource.sample(n);
  List<String> list = [];
  List<String> questions = [];
  List<String> answers = [];
  Timer? countdownTimer;
  int numOfPairs = 3;
  int firstSelected = -1;
  bool isNotCorrect = true;
  bool isStop = false;
  final double runSpacing = 4;
  final double spacing = 4;
  int tempPoint = 600;
  int columns = 5;
  int round = 1;
  int point = 0;
  int second = 15;
  late Duration myDuration = Duration(seconds: second);

  Future _initImages() async {
    List<String> easy = ['Animal/', 'FruitVegetable/', 'HouseholdItem/'];
    List<String> medium = ['Transportation/'];

    switch (widget.difficulty) {
      case GameDifficulty.EASY:
        getAllPictures(easy);
        break;
      case GameDifficulty.MEDIUM:
        getAllPictures(medium);
        break;
      default:
    }
  }

  Future<void> getAllPictures(List<String> listFolder) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    for (var element in listFolder) {
      final imagePaths = manifestMap.keys
          .where((String key) => key.contains('images/'))
          .where((String key) => key.contains(element))
          .toList();
      list.addAll(imagePaths);
    }
    setState(() {
      answers = getList(numOfPairs, list);
    });
    duplicateAnswers();
  }

  void resetRound() {
    calPoint();
    questions.clear();
    answers.clear();
    round++;
    numOfPairs++;
    isStop = false;
    second += 5;
    tempPoint += 200;
    answers = getList(numOfPairs, list);
    duplicateAnswers();
    resetTimer();
    startTimer();
  }

  void calPoint() {
    if (questions.isEmpty) {
      point += tempPoint;
    }
  }

  void duplicateAnswers() {
    setState(() {
      questions.addAll(answers);
      questions.addAll(answers);
      questions.shuffle();
    });
  }

  void handleClick(int index) {
    setState(() {
      if (firstSelected == index) {
        firstSelected = -1;
      }
      if (firstSelected == -1) {
        firstSelected = index;
      } else {
        checker(questions[firstSelected], questions[index]);
        isNotCorrect = false;
        firstSelected = -1;
      }
    });
  }

  void checker(String first, String second) {
    if (first == second) {
      questions.removeWhere((element) => element == second);
    } else {
      isNotCorrect = true;
    }
  }

  void resetTimer() {
    setState(() {
      myDuration = Duration(seconds: second);
    });
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void addTimer() {
    setState(() {
      myDuration = Duration(seconds: myDuration.inSeconds + 10);
    });
  }

  void minusTimer() {
    final seconds = myDuration.inSeconds - 2;
    setState(() {
      if (seconds < 0) {
        setCancelTimer();
      } else {
        myDuration = Duration(seconds: myDuration.inSeconds - 2);
      }
    });
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0 || questions.isEmpty) {
        setCancelTimer();
        isStop = true;
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  void setCancelTimer() {
    countdownTimer!.cancel();
  }

  @override
  void initState() {
    super.initState();
    _initImages();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    countdownTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = myDuration.inSeconds;
    final w =
        (MediaQuery.of(context).size.width - runSpacing * (columns - 0.8)) /
            columns;
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: isStop
          ? FloatingActionButton.extended(
              onPressed: () => resetRound(),
              label: Row(
                children: [
                  Text("Màn kế tiếp "),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              '$seconds',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),
            Text(
              point.toString(),
              style: const TextStyle(fontSize: 30, color: Colors.red),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Wrap(
                  runSpacing: runSpacing,
                  spacing: spacing,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    questions.length,
                    (index) {
                      return InkWell(
                        splashColor: isNotCorrect ? Colors.red : null,
                        onTap: () => isStop ? null : handleClick(index),
                        child: Container(
                          width: w,
                          height: w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(questions[index]),
                                colorFilter: firstSelected == index
                                    ? ColorFilter.mode(
                                        Colors.black.withOpacity(0.2),
                                        BlendMode.dstATop)
                                    : null),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
