import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:brain_training/constants/enum.dart';
import 'package:brain_training/utils/helper.dart';

class LanguageGameFour extends StatefulWidget {
  const LanguageGameFour({Key? key}) : super(key: key);

  @override
  State<LanguageGameFour> createState() => _LanguageGameFourState();
}

class _LanguageGameFourState extends State<LanguageGameFour> {
  final String languageGameFourPath = "lib/constants/language_game.json";
  final String jsonKey = "languageGame4";
  final int questionDurationInSecond = 60;
  final int numberOfQuestions = 10;

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
        _showMyDialog("Kết thúc", () {
          Navigator.of(context).pop();
        });
        break;
      default:
        break;
    }
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
        title: const Text("Sắp xếp chữ cái"),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(children: [
          Text(
            '$seconds',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 50),
          ),
          Text(
            "Điểm: $_point",
            style: const TextStyle(fontSize: 30, color: Colors.red),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text("Hãy sắp xếp các chữ cái để tạo thành một từ",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
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
            style: TextStyle(fontSize: 26),
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
                    "Đáp án",
                    style: TextStyle(fontSize: 26),
                  ),
                  _solutionWord.isEmpty
                      ? Container()
                      : wordButtonWidget(_solutionWord, ButtonType.solution),
                ]),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed:
                (!_answerWord.contains("") && _status == GameStatus.playing)
                    ? () => handleClickCheck()
                    : null,
            child: const Text("Kiểm tra", style: TextStyle(fontSize: 24)),
          )
        ])),
      ),
      floatingActionButton: _currentQuestion < _wordsList.length - 1
          ? FloatingActionButton.extended(
              onPressed: _status == GameStatus.checking
                  ? () => handleClickNext()
                  : null,
              icon: const Icon(Icons.navigate_next),
              label: Text("Bài tập ${_currentQuestion + 2}"),
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
    return wordWidget(char, onPressedCallback: () {
      selectAnswer(char, index);
    });
  }

  // Handle logic for answer button's style
  ButtonStyle? getAnswerBtnStyle() {
    if (_status == GameStatus.playing) {
      return null;
    } else if (_isCorrect) {
      return ElevatedButton.styleFrom(backgroundColor: Colors.green);
    }
    return ElevatedButton.styleFrom(backgroundColor: Colors.red);
  }

  Expanded answerWidget(int index, String char) {
    return wordWidget(char, buttonStyle: getAnswerBtnStyle(),
        onPressedCallback: () {
      deleteAnswer(char, index);
    });
  }

  Expanded solutionWidget(int index, String char) {
    return wordWidget(char,
        buttonStyle: ElevatedButton.styleFrom(backgroundColor: Colors.green));
  }

  Expanded wordWidget(String char,
      {ButtonStyle? buttonStyle, Function? onPressedCallback}) {
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
                child: Text(char, style: const TextStyle(fontSize: 30)))));
  }

  Future<void> _showMyDialog(String title, Function callback) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Điểm: $_point"),
                Text("Điểm thưởng: $_bonusPoint"),
                Text("Thời gian trả lời: $_responseTime giây"),
                Text("Tổng điểm: ${_point + _bonusPoint}"),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              child: const Text('Xác nhận'),
              onPressed: () => callback(),
            ),
          ],
        );
      },
    );
  }
}
