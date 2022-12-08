import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:brain_training/constants/color.dart';
import 'package:flutter_svg/svg.dart';

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
  int conditionPassLevel = 0;
  num totalScore = 0;
  @override
  void initState() {
    super.initState();
    readJson();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    countdownTimer!.cancel();
    currentIndexing = 0;
    currentRound = 1;
    amountOfCorrectAnswers = 0;
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    () => countdownTimer!.cancel();
  }

  num calculateScore() {
    dynamic totalTimeOfLevel = currentGridData.reduce((value, element) {
      return {
        "duration": value["duration"] + element["duration"],
      };
    });
    num duration = totalTimeOfLevel["duration"];
    num averageTime = duration / currentGridData.length;
    num bonusScore = currentScore / averageTime;
    num totalScoreDouble = currentScore + bonusScore;
    totalScore = totalScoreDouble.round();
    return totalScore;
  }

  void setCancelTimer() {
    int timer = currentGridData[0]["duration"] - 1;
    calculateScore();
    countdownTimer!.cancel();
    _showMyDialog(
        "Kết thúc",
        "Số vòng chơi vượt qua: $amountOfCorrectAnswers / ${currentGridData.length}",
        "Tổng điểm: $totalScore", () {
      Navigator.of(context).pop();
      setState(() {
        currentIndexing = 0;
        currentRound = 1;
        currentScore = 0;
        timerCounter = Duration(seconds: timer);
        clickedOptions = [];
      });
      startTimer();
    });
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = timerCounter.inSeconds - reduceSecondsBy;
      int timer = currentGridData[currentIndexing]["duration"] - 1;
      if (seconds < 0) {
        if (currentIndexing < currentGridData.length - 1) {
          currentIndexing++;
          currentRound++;
          timerCounter = Duration(seconds: timer);
        } else if (currentIndexing == currentGridData.length - 1) {
          if (currentMultipleType == 1 && amountOfCorrectAnswers >= 14) {
            setState(() {
              currentIndexing = 0;
              currentRound = 1;
              currentMultipleType = 2;
              amountOfCorrectAnswers = 0;
              clickedOptions = [];
              timerCounter = Duration(seconds: timer);
              currentGridData = gridDataHundred;
            });
          } else if (currentMultipleType == 2 && amountOfCorrectAnswers >= 18) {
            setState(() {
              currentIndexing = 0;
              currentRound = 1;
              currentMultipleType = 3;
              amountOfCorrectAnswers = 0;
              clickedOptions = [];
              timerCounter = Duration(seconds: timer);
              currentGridData = gridDataThousand;
            });
          } else {
            setCancelTimer();
          }
        }
      } else {
        timerCounter = Duration(seconds: seconds);
      }
    });
  }

  Future<void> _showMyDialog(String title, String content, String totalScore,
      Function callback) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 40,
                      fontWeight: FontWeight.w600)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      content,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      totalScore,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    color: orangePastel,
                  ),
                  child: TextButton(
                    child: const Text('Chơi lại',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onPressed: () => callback(),
                  ),
                )
              ],
            ));
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

  String gameType() {
    if (currentMultipleType == 1) {
      return "10";
    } else if (currentMultipleType == 2) {
      return "100";
    } else {
      return "1000";
    }
  }

  @override
  Widget build(BuildContext context) {
    int seconds = timerCounter.inSeconds;
    String clockIcon = "lib/assets/icons/clock_ic.svg";
    return Scaffold(
        appBar: AppBar(
          title: Text('Tìm tổng 2 số có tổng là ${gameType()}'),
          backgroundColor: orangePastel,
          foregroundColor: darkTextColor,
          titleTextStyle: const TextStyle(
            color: darkTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  "Điểm: $currentScore",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: primaryOrange,
                      fontSize: 35),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    clockIcon,
                    height: 35,
                    width: 35,
                    color: seconds <= 2 ? Colors.red : darkTextColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  clockTimer(seconds)
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: gridOptions(currentGridData),
              )
            ],
          ),
        ));
  }

  Widget clockTimer(int seconds) {
    if (seconds <= 2) {
      return Text(
        '00:${seconds <= 9 ? '0$seconds' : '$seconds'}',
        style: const TextStyle(
            fontWeight: FontWeight.w700, color: Colors.red, fontSize: 20),
      );
    } else {
      return Text(
        '00:${seconds <= 9 ? '0$seconds' : '$seconds'}',
        style: const TextStyle(
            fontWeight: FontWeight.w700, color: darkTextColor, fontSize: 20),
      );
    }
  }

  GridView gridOptions(List gridData) {
    void validateAnswer(String typeValidate) {
      int timer = gridData[currentIndexing]["duration"] - 1;
      int gridDataLength = gridData.length;
      int conditionPassLevelTen = 14;
      int conditionPassLevelHundred = 18;
      if (typeValidate == "ten") {
        if (currentIndexing == gridData.length - 1 &&
            amountOfCorrectAnswers >= conditionPassLevelTen) {
          setState(() {
            currentIndexing = 0;
            currentRound = 1;
            amountOfCorrectAnswers = 0;
            clickedOptions = [];
            currentGridData = gridDataHundred;
            timerCounter = Duration(seconds: timer);
          });
        } else if (currentIndexing == gridDataLength - 1 &&
            amountOfCorrectAnswers < conditionPassLevelTen) {
          setCancelTimer();
        } else {
          if (clickedOptions[0] + clickedOptions[1] == 10) {
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
      } else if (typeValidate == "hundred") {
        if (currentIndexing == gridDataLength - 1 &&
            amountOfCorrectAnswers >= conditionPassLevelHundred) {
          setState(() {
            currentIndexing = 0;
            currentRound = 1;
            amountOfCorrectAnswers = 0;
            clickedOptions = [];
            currentGridData = gridDataThousand;
            timerCounter = Duration(seconds: timer);
          });
        } else if (currentIndexing == gridDataLength - 1 &&
            amountOfCorrectAnswers < conditionPassLevelHundred) {
          setCancelTimer();
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
        if (currentIndexing == gridDataLength - 1) {
          setState(() {
            currentIndexing = 0;
            currentRound = 1;
            amountOfCorrectAnswers = 0;
            clickedOptions = [];
          });
          calculateScore();
          _showMyDialog(
              "Kết thúc",
              "Số vòng chơi vượt qua: $amountOfCorrectAnswers / ${currentGridData.length}",
              "Tổng điểm của vòng chơi: $totalScore", () {
            Navigator.of(context).pop();
            setState(() {
              currentIndexing = 0;
              currentRound = 1;
              currentGridData = gridDataThousand;
              timerCounter = Duration(seconds: timer);
              clickedOptions = [];
            });
            startTimer();
          });
        } else {
          if (clickedOptions[0] + clickedOptions[1] == 1000) {
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
            Future.delayed(const Duration(milliseconds: 200), () {
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
          return GestureDetector(
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
                              ? greenBtn
                              : orangePastel,
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
