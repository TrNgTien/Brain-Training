import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:brain_training/constants/enum.dart';
import 'package:brain_training/constants/color.dart';
import 'package:brain_training/utils/helper.dart';
import 'package:brain_training/widget/clock.dart';
import 'package:brain_training/utils/custom_dialog.dart';

class LanguageGameFour extends StatefulWidget {
  const LanguageGameFour({Key? key}) : super(key: key);

  @override
  State<LanguageGameFour> createState() => _LanguageGameFourState();
}

class _LanguageGameFourState extends State<LanguageGameFour> {
  final String jsonKey = "languageGame4";
  final int questionDurationInSecond = 60;
  final int numberOfQuestions = 10;
  String languageGameFourPath = "lib/constants/language_game.json";

  late CustomDialog dialog;
  Duration questionDuration = const Duration();
  Timer? countdownTimer;

  List _wordsList = [];
  List<String> _questionWord = [];
  List<String> _answerWord = [];
  List<int> _answerIndex = [];
  List<String> _solutionWord = [];

  int _currentAnswerPosition = 0;
  int _currentQuestion = 0;
  bool _isCorrect = false;

  int _point = 0;
  int _bonusPoint = 0;
  int _responseTime = 0;
  GameStatus _status = GameStatus.playing;

  // Question handler
  void updateSession() {
    changeQuestionWord();
    changeSolutionWord();
    resetAnswer();
    startTimer();
  }

  void nextQuestion() {
    if (_currentQuestion >= _wordsList.length - 1) return;

    increaseQuestionNumber();
    updateSession();
  }

  void calculateBonusPoints() {
    double averageResponseTime = _responseTime / numberOfQuestions;
    double bonusPoints = _point / averageResponseTime;
    setState(() {
      _bonusPoint = bonusPoints.toInt();
    });
  }

  void increaseQuestionNumber() {
    setState(() {
      _currentQuestion++;
    });
  }

  void changeQuestionWord() {
    setState(() {
      _questionWord =
          _wordsList[_currentQuestion]["question"].toString().split("");
    });
  }

  void changeSolutionWord() {
    setState(() {
      _solutionWord =
          _wordsList[_currentQuestion]["solution"].toString().split("");
    });
  }

  void resetAnswer() {
    int listLength = _wordsList[_currentQuestion]["question"].toString().length;
    setState(() {
      _isCorrect = false;
      _answerWord = List.filled(listLength, "");
      _answerIndex = List.filled(listLength, -1);
      _currentAnswerPosition = 0;
    });
  }

  // Click Handler
  void handleClickCheck() {
    changeStatus(GameStatus.checking);

    checkAnswer();
  }

  void handleClickNext() {
    nextQuestion();
  }

  void selectAnswer(String char, int index) {
    setState(() {
      _answerWord[_currentAnswerPosition] = char;
      _answerIndex[_currentAnswerPosition] = index;

      _questionWord[index] = "";
      _currentAnswerPosition = _answerWord.indexOf("");
    });
  }

  void deleteAnswer(String char, int index) {
    setState(() {
      _questionWord[_answerIndex[index]] = char;

      _answerWord[index] = "";
      _answerIndex[index] = -1;

      if (index < _currentAnswerPosition || _currentAnswerPosition == -1) {
        _currentAnswerPosition = index;
      }
    });
  }

  void checkAnswer() {
    if (listEquals(_solutionWord, _answerWord)) {
      setState(() {
        _isCorrect = true;
        _point += 200;
      });
    }
  }

  void userFinishQuestion() {
    setCancelTimer();
    updateUserResponseTime();
  }

  void updateUserResponseTime() {
    setState(() {
      _responseTime += (questionDurationInSecond - questionDuration.inSeconds);
    });
  }

  void changeStatus(GameStatus status) {
    handleStatusChange(status);

    setState(() {
      _status = status;
    });
  }

  void handleStatusChange(GameStatus status) {
    switch (status) {
      case GameStatus.checking:
        userFinishQuestion();
        break;
      case GameStatus.end:
        userFinishQuestion();
        calculateBonusPoints();
        showEndGameDialog();
        break;
      default:
        break;
    }
  }

  void showEndGameDialog() {
    dialog.show(
        Text("Kết thúc"),
        SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("Điểm: $_point"),
              Text("Điểm thưởng: $_bonusPoint"),
              Text("Thời gian trả lời: $_responseTime giây"),
              Text("Tổng điểm: ${_point + _bonusPoint}"),
            ],
          ),
        ),
        [
          TextButton(
            child: const Text('Xác nhận'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ]);
  }

  // Timer Handler
  void startTimer() {
    questionDuration = Duration(seconds: questionDurationInSecond);
    changeStatus(GameStatus.playing);

    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = questionDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0 && _currentQuestion >= _wordsList.length - 1) {
        changeStatus(GameStatus.end);
      } else if (seconds < 0) {
        changeStatus(GameStatus.checking);
      } else {
        questionDuration = Duration(seconds: seconds);
      }
    });
  }

  void setCancelTimer() {
    countdownTimer!.cancel();
  }

  @override
  void initState() {
    super.initState();
    dialog = CustomDialog(context: context);
    readJson(languageGameFourPath, jsonKey).then((wordsList) {
      // Shuffle the questions list
      wordsList.shuffle();
      setState(() {
        _wordsList = wordsList.sublist(0, numberOfQuestions);
      });

      updateSession();
    });
  }

  @override
  void dispose() {
    super.dispose();
    setCancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = questionDuration.inSeconds;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: yellowPastel,
        foregroundColor: darkTextColor,
        title: Text("Màn ${_currentQuestion + 2}"),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 10),
            child: Text(
              "Điểm: $_point",
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: primaryOrange,
                  fontSize: 35),
            ),
          ),
          Clock(seconds: seconds),
          const SizedBox(
            height: 30,
          ),
          const Text("Hãy sắp xếp các chữ cái để tạo thành một từ",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: darkTextColor)),
          const SizedBox(
            height: 30,
          ),
          _questionWord.isEmpty
              ? Container()
              : wordButtonWidget(_questionWord, ButtonType.question),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Trả lời:",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: darkTextColor),
          ),
          _answerWord.isEmpty
              ? Container()
              : wordButtonWidget(_answerWord, ButtonType.answer),
          _status == GameStatus.playing
              ? Container()
              : Column(children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Đáp án:",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: darkTextColor),
                  ),
                  _solutionWord.isEmpty
                      ? Container()
                      : wordButtonWidget(_solutionWord, ButtonType.solution),
                ]),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(180, 211, 161, 1)),
              onPressed:
                  (!_answerWord.contains("") && _status == GameStatus.playing)
                      ? () => handleClickCheck()
                      : null,
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Kiểm tra",
                    style: TextStyle(
                        fontSize: 20,
                        color: darkTextColor,
                        fontWeight: FontWeight.w600)),
              ))
        ])),
      ),
      floatingActionButton: _currentQuestion < _wordsList.length - 1 &&
              _status == GameStatus.checking
          ? FloatingActionButton.extended(
              backgroundColor: Color.fromRGBO(246, 204, 131, 1),
              onPressed: () => handleClickNext(),
              icon: const Icon(Icons.navigate_next, color: darkTextColor),
              label: Text("Màn kế tiếp",
                  style: TextStyle(
                      color: darkTextColor, fontWeight: FontWeight.w800)),
            )
          : null,
    );
  }

  Column wordButtonWidget(List<String> wordList, ButtonType type) {
    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: wordList.asMap().entries.map((entry) {
            switch (type) {
              case ButtonType.question:
                return questionWidget(entry.key, entry.value);
              case ButtonType.answer:
                return answerWidget(entry.key, entry.value);
              case ButtonType.solution:
                return solutionWidget(entry.key, entry.value);
            }
          }).toList()),
    ]);
  }

  Expanded questionWidget(int index, String char) {
    return wordWidget(char,
        buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(250, 173, 140, 1)),
        textStyle: TextStyle(color: darkTextColor), onPressedCallback: () {
      selectAnswer(char, index);
    });
  }

  // Handle logic for answer button's style
  ButtonStyle? getAnswerBtnStyle() {
    if (_status == GameStatus.playing) {
      return ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(250, 173, 140, 1));
    } else if (_isCorrect) {
      return ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(180, 211, 161, 1));
    }
    return ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(234, 67, 53, 1));
  }

  TextStyle? getAnswerTextStyle() {
    if (_status == GameStatus.playing) {
      return TextStyle(color: darkTextColor);
    } else if (_isCorrect) {
      return TextStyle(color: darkTextColor);
    }
    return TextStyle(color: Colors.white);
  }

  Expanded answerWidget(int index, String char) {
    return wordWidget(char,
        textStyle: getAnswerTextStyle(),
        buttonStyle: getAnswerBtnStyle(), onPressedCallback: () {
      deleteAnswer(char, index);
    });
  }

  Expanded solutionWidget(int index, String char) {
    return wordWidget(char,
        textStyle: TextStyle(color: darkTextColor),
        buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(180, 211, 161, 1)));
  }

  Expanded wordWidget(String char,
      {ButtonStyle? buttonStyle,
      TextStyle? textStyle,
      Function? onPressedCallback}) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.all(4),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  fixedSize: const Size.fromHeight(70),
                ).merge(buttonStyle),
                onPressed: () {
                  if (_status == GameStatus.checking) return;
                  if (char == "") return;
                  onPressedCallback!();
                },
                child: Text(char,
                    style: const TextStyle(fontSize: 30).merge(textStyle)))));
  }
}
