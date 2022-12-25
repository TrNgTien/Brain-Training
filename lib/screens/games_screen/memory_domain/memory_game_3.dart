import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:brain_training/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

import '../../../widget/clock.dart';

class MemoryGame3 extends StatefulWidget {
  const MemoryGame3({Key? key}) : super(key: key);

  @override
  State<MemoryGame3> createState() => _MemoryGame3State();
}

class _MemoryGame3State extends State<MemoryGame3> {
  final random = Random();
  List<String> getList(int n, List<String> listSource) => listSource.sample(n);

  Timer? countdownTimer;

  List<String> list = [];
  List<String> initCards = [];
  List<String> answers = [];
  List<String> questions = [];
  List<String> questionsSelected = [];
  List<String> animalImages = [];
  List<String> transportationImages = [];
  List<List<String>> l1 = [[]];

  List<bool> isSelected = <bool>[];
  int point = 0;
  int round = 1;
  int level = 1;
  int countWhile = 0;
  int seconds = 3;
  bool isEnd = false;
  bool isAnswer = false;
  late Duration myDuration = Duration(seconds: seconds);

  void handleSubmit() => {
        setState(() => {
              collectQuestionsSelected(),
              resetTimer(),
              stopTimer(),
              isEnd = true,
              if (checkCorrect() && questionsSelected.isNotEmpty)
                point += (level * 200),
            }),
      };
  void resetRound() {
    setState(() {
      initCards.clear();
      answers.clear();
      questions.clear();
      questionsSelected.clear();
      isSelected.clear();
      countWhile = 0;
      isEnd = false;
      isAnswer = false;
      round++;
      addTimer(3);
      changeLevel();
      startTimer();
      initCards = getList(4, list);
    });
  }

  bool checkCorrect() {
    return questionsSelected
        .toSet()
        .difference(answers.toSet())
        .toList()
        .isEmpty;
  }

  void changeLevel() {
    switch (round) {
      case 5:
        level++;
        break;
      case 9:
        level++;
        break;
      default:
    }
  }

  void collectQuestionsSelected() {
    questionsSelected = [
      ...questions
          .where((element) => isSelected[questions.indexOf(element)] == true)
    ];
  }

  void setQuestions() => {
        setState(() {
          if (initCards.isNotEmpty) {
            answers = [...initCards.sublist(initCards.length - level)];
            initCards.fillRange(
                initCards.length - level, initCards.length, '?');
            initCards.shuffle();
            createQuestions(level + 2);
          }
        }),
      };
  void createQuestions(int nAnsCards) => {
        questions.addAll(answers),
        questions.addAll(takeNonDuplicateQuestion()),
        questions.shuffle(),
        isSelected = [...List.filled(questions.length, false)],
      };

  List<String> takeNonDuplicateQuestion() {
    List<String> dumQuestions = [];
    while (countWhile < level + 2) {
      String dumQuestion = list[random.nextInt(list.length)];
      if (!answers.contains(dumQuestion) &&
          !initCards.contains(dumQuestion) &&
          !dumQuestions.contains(dumQuestion)) {
        dumQuestions.add(dumQuestion);
        countWhile++;
      }
    }
    return dumQuestions;
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void addTimer(int addTimer) {
    setState(() {
      myDuration = Duration(seconds: myDuration.inSeconds + addTimer);
      // seconds = addTimer;
    });
  }

  void resetTimer() {
    setState(() {
      myDuration = const Duration(seconds: 0);
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
      var seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        if (isAnswer) {
          // setCancelTimer();
          handleSubmit();
        } else {
          setQuestions();
          isAnswer = true;
          addTimer(10);
        }
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  void setCancelTimer() {
    countdownTimer!.cancel();
  }

  Future _initImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths1 = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Animal/'))
        .toList();
    final imagePaths2 = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Transportation/'))
        .toList();

    setState(() {
      list = imagePaths1;
      initCards = getList(4, imagePaths1);

      // l1[0] = imagePaths1;
      // l1[1] = imagePaths2;
    });
  }

  @override
  void initState() {
    super.initState();
    _initImages();
    seconds = 3;
    // getList(4, list);
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
    // print(l1[1]);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Màn " + round.toString()),
          backgroundColor: orangePastel,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Clock(seconds: seconds),
                  ],
                ),
              ),
              Text("Điểm: $point",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: brownColor,
                      fontSize: 30)),
              const Padding(
                padding: EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                ),
              ),
              list.isNotEmpty
                  ? GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      children: initCards
                          .map(
                            (e) => e != '?'
                                ? Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: orangePastel),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: Image.asset(
                                        e,
                                        height: 50,
                                        width: 50,
                                      ),
                                    ))
                                : Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: orangePastel),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                        child: Text("?",
                                            style: TextStyle(fontSize: 50))),
                                  ),
                          )
                          .toList(),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Chọn $level hình",
                ),
              ),
              questions.isNotEmpty ? ansToggleBtn() : Container(),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Đáp án",
                ),
              ),
              isEnd
                  ? Container(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: answers
                          .map((e) => e != '?'
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: pinkPastel),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: Image.asset(
                                      e,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                )
                              : Text("?", style: TextStyle(fontSize: 10)))
                          .toList(),
                    ))
                  : Container(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: greenBtn),
                      onPressed:
                          isSelected.where((c) => c == true).length == level &&
                                  !isEnd
                              ? handleSubmit
                              : null,
                      child: const Text("Kiểm tra")),
                  round < 10
                      ? ElevatedButton(
                          onPressed: resetRound,
                          child: const Text(
                            "Vòng tiếp theo",
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: pinkBtn),
                        )
                      : Container()
                ],
              )
            ],
          ),
        ));
  }

  Widget ansToggleBtn() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.25,
      child: GridView.count(
        primary: true,
        crossAxisCount: level == 2 ? 3 : 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: List.generate(isSelected.length, (index) {
          return InkWell(
            highlightColor: orangePastel,
            onTap: () {
              setState(() {
                for (int indexBtn = 0;
                    indexBtn < isSelected.length;
                    indexBtn++) {
                  isSelected.where((item) => item == true).length < level ||
                          isSelected[indexBtn] == true
                      ? setState(() {
                          if (indexBtn == index) {
                            isSelected[index] = !isSelected[index];
                          }
                        })
                      : null;
                }
              });
            },
            child: Ink(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(questions[index]),
                    colorFilter: isSelected[index]
                        ? ColorFilter.mode(
                            Colors.black.withOpacity(0.2), BlendMode.dstATop)
                        : null),
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: orangePastel),
              ),
              // child: Text(questions[index]),
            ),
          );
        }),
      ),
    );
  }
}
