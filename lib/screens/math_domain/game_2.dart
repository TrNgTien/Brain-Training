import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mobile_proj/utils/helper.dart';

class Game2 extends StatefulWidget {
  const Game2({super.key});

  @override
  State<Game2> createState() => _Game2State();
}

class _Game2State extends State<Game2> {
  String mathGamePath = "lib/constants/math-game-2.json";
  Timer? countdownTimer;
  Duration timerCounter = const Duration(seconds: 9);
  List gridDataTen = [];
  List gridDataHundred = [];
  List gridDataThousand = [];
  List currentGridData = [];
  num currentScore = 0;
  List<int> clickedOptions = [];
  int currentRound = 1;
  int currentMultipleType = 1;
  int currentIndexing = 0;
  int amountOfCorrectAnswers = 0;
  int indexClicked = 0;
  @override
  void initState() {
    super.initState();
    readJson();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    setCancelTimer();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void setCancelTimer() {
    countdownTimer!.cancel();
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    print("currentIndexing: $currentIndexing");

    setState(() {
      final seconds = timerCounter.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        int timer = currentGridData[currentIndexing]["duration"] - 1;
        if (currentIndexing < currentGridData.length - 1) {
          currentIndexing++;
          currentRound++;
          stopTimer();
        } else if (currentIndexing == currentGridData.length - 1 &&
            currentMultipleType == 1 &&
            amountOfCorrectAnswers >= 14) {
          setState(() {
            currentIndexing = 0;
            currentRound = 1;
            currentMultipleType = 2;
            timerCounter = Duration(seconds: timer);
            currentGridData = gridDataHundred;
          });
        } else if (currentIndexing == currentGridData.length - 1 &&
            currentMultipleType == 2 &&
            amountOfCorrectAnswers >= 18) {
          setState(() {
            currentIndexing = 0;
            currentRound = 1;
            currentMultipleType = 3;
            timerCounter = Duration(seconds: timer);
            currentGridData = gridDataThousand;
          });
        }
      } else {
        timerCounter = Duration(seconds: seconds);
      }
    });
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString(mathGamePath);
    final data = await json.decode(response);
    setState(() {
      gridDataTen = data["multiple_of_ten"];
      currentGridData = gridDataTen;
      gridDataHundred = data["multiple_of_hundred"];
      gridDataThousand = data["multiple_of_thousand"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final seconds = timerCounter.inSeconds;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tìm tổng 2 số'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  "Điểm: $currentScore",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 35),
                ),
              ),
              Text(
                'Thời gian: $seconds giây',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: gridOptions(currentGridData),
              )
            ],
          ),
        ));
  }

  GridView gridOptions(List gridData) {
    void validateAnswer(String typeValidate) {
      int timer = gridData[currentIndexing]["duration"] - 1;
      if (typeValidate == "ten") {
        if (currentIndexing == gridData.length &&
            amountOfCorrectAnswers >= 14) {
          setState(() {
            currentIndexing = 0;
            currentRound = 1;
            clickedOptions = [];
            currentGridData = gridDataHundred;
          });
        } else if (currentIndexing == gridData.length) {
          setState(() {
            currentIndexing = 0;
            currentRound = 1;
            clickedOptions = [];
            currentGridData = gridDataHundred;
          });
        } else {
          if (clickedOptions[0] + clickedOptions[1] == 10) {
            setState(() {
              currentIndexing++;
              currentRound++;
              currentScore += gridData[currentIndexing]["points"];
              amountOfCorrectAnswers++;
              timerCounter = Duration(seconds: timer);
              clickedOptions = [];
            });
          } else {
            setState(() {
              currentIndexing++;
              currentRound++;
              timerCounter = Duration(seconds: timer);
              clickedOptions = [];
            });
          }
        }
      } else if (typeValidate == "hundred") {
        if (currentIndexing == gridData.length &&
            amountOfCorrectAnswers >= 18) {
          setState(() {
            currentIndexing = 0;
            currentRound = 1;
            clickedOptions = [];
            currentGridData = gridDataThousand;
          });
        } else {
          if (clickedOptions[0] + clickedOptions[1] == 100) {
            setState(() {
              currentIndexing++;
              currentRound++;
              amountOfCorrectAnswers++;
              currentScore += gridData[currentIndexing]["points"];
              timerCounter = Duration(seconds: timer);
              clickedOptions = [];
            });
          } else {
            setState(() {
              currentIndexing++;
              currentRound++;
              timerCounter = Duration(seconds: timer);
              clickedOptions = [];
            });
          }
        }
      } else {
        if (currentIndexing == gridData.length - 1) {
          setState(() {
            currentIndexing = 0;
            currentRound = 1;
            clickedOptions = [];
            stopTimer();
          });
        } else {
          if (clickedOptions[0] + clickedOptions[1] == 1000) {
            setState(() {
              currentIndexing++;
              currentRound++;
              currentScore += gridData[currentIndexing]["points"];
              timerCounter = Duration(seconds: timer);
              clickedOptions = [];
            });
          } else {
            setState(() {
              currentIndexing++;
              currentRound++;
              timerCounter = Duration(seconds: timer);
              clickedOptions = [];
            });
          }
        }
      }
    }

    String verifyChangeType(int currentMultipleType) {
      if (currentMultipleType == 1) {
        return "ten";
      } else if (currentMultipleType == 2) {
        return "hundred";
      } else {
        return "thousand";
      }
    }

    void handleAddOption(int option, int index) {
      if (clickedOptions.isNotEmpty) {
        if (clickedOptions.contains(option) && index == indexClicked) {
          setState(() {
            clickedOptions.remove(option);
          });
        } else {
          setState(() {
            indexClicked = index;
            clickedOptions.add(option);
            Future.delayed(const Duration(milliseconds: 300), () {
              validateAnswer(verifyChangeType(currentMultipleType));
            });
          });
        }
      } else {
        setState(() {
          indexClicked = index;
          clickedOptions.add(option);
        });
      }
    }

    bool validateHighLight(int indexGrid) {
      List<dynamic> optionsRound =
          gridData[currentIndexing]["round_$currentRound"];
      return clickedOptions.isNotEmpty &&
          clickedOptions.contains(optionsRound[indexGrid]) &&
          indexGrid == indexClicked;
    }

    return GridView.builder(
        shrinkWrap: true,
        itemCount: gridData.isNotEmpty
            ? gridData[currentIndexing]["round_$currentRound"].length
            : 0,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (_, int indexGrid) {
          return InkWell(
            onTap: () => handleAddOption(
                gridData.isNotEmpty
                    ? gridData[currentIndexing]["round_$currentRound"]
                        [indexGrid]
                    : null,
                indexGrid),
            child: gridData.isNotEmpty
                ? GridTile(
                    child: Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                          color: validateHighLight(indexGrid)
                              ? Colors.blue
                              : Colors.blue[50],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                  "${gridData[currentIndexing]["round_$currentRound"][indexGrid]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 50,
                                  )),
                            ))))
                : const Text("Loading"),
          );
        });
  }
}
