import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MemoryGame3 extends StatefulWidget {
  const MemoryGame3({Key? key}) : super(key: key);

  @override
  State<MemoryGame3> createState() => _MemoryGame3State();
}

class _MemoryGame3State extends State<MemoryGame3> {
  List<String> getList(int n, List<String> listSource) => listSource.sample(n);
  Timer? countdownTimer;

  List<String> list = [
    'aaa',
    'bbb',
    'ccc',
    'ddd',
    'eee',
    'fff',
    'ggg',
    'hhh',
    'iii',
    'kkk',
    'lll',
    'mmm',
    'nnn',
    'ooo',
    'ppp',
    'qqq',
    'sss'
  ];
  List<String> initCards = [];
  List<String> answers = [];
  List<String> questions = [];
  List<String> questionsSelected = [];
  List<bool> isSelected = <bool>[];
  int point = 0;
  int round = 1;
  int level = 1;
  int countWhile = 0;
  int seconds = 3;
  bool isEnd = false;
  bool isAnswer = false;
  late Duration myDuration = Duration(seconds: seconds);
  final random = Random();

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
      initCards = [...getList(4, list)];
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
          answers = [...initCards.sublist(initCards.length - level)];
          initCards.fillRange(initCards.length - level, initCards.length, '?');
          initCards.shuffle();
          createQuestions(level + 2);
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

  @override
  void initState() {
    super.initState();
    seconds = 3;
    initCards = [...getList(4, list)];
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
    return Scaffold(
        appBar: AppBar(),
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
                "Điểm: $point",
                style: const TextStyle(fontSize: 30, color: Colors.red),
              ),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                children: initCards
                    .map((e) => Center(
                          child: Text(
                            e,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ))
                    .toList(),
              ),
              const Text("Chon 3 dap an"),
              questions.isNotEmpty ? ansToggleBtn() : Container(),
              isEnd
                  ? GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      children: answers
                          .map((e) => Center(
                                child: Text(
                                  e,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ))
                          .toList(),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed:
                          isSelected.where((c) => c == true).length == level &&
                                  !isEnd
                              ? handleSubmit
                              : null,
                      child: const Text("check")),
                  ElevatedButton(
                      onPressed: resetRound, child: const Text("reset"))
                ],
              )
            ],
          ),
        ));
  }

  Ink ansToggleBtn() {
    return Ink(
      width: 200,
      height: 100,
      color: Colors.white,
      child: GridView.count(
        primary: true,
        crossAxisCount: level == 2 ? 3 : 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: List.generate(isSelected.length, (index) {
          return InkWell(
            splashColor: Colors.yellow,
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
                  // image: DecorationImage(image: ),
                  color: isSelected[index]
                      ? const Color.fromARGB(255, 83, 179, 248)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Text(questions[index])),
          );
        }),
      ),
    );
  }
}
