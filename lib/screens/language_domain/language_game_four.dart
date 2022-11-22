import 'dart:async';
import 'dart:convert';
import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension Shuffle on String {
  String get shuffled => (characters.toList()..shuffle()).join('');
}

enum ButtonType { question, answer, solution }

enum GameStatus { playing, checking }

class LanguageGameFour extends StatefulWidget {
  const LanguageGameFour({Key? key}) : super(key: key);

  @override
  State<LanguageGameFour> createState() => _LanguageGameFourState();
}

class _LanguageGameFourState extends State<LanguageGameFour> {
  final String languageGameFourPath = "lib/constants/language_game.json";
  Duration questionDuration = const Duration(seconds: 20);
  Timer? countdownTimer;

  List _wordsList = [];
  List<String> _questionWord = [];
  List<String> _answerWord = [];
  List<int> _answerIndex = [];
  List<String> _solutionWord = [];
  int _currentAnswerPosition = 0;
  int _currentQuestion = 0;
  int _point = 0;
  GameStatus _status = GameStatus.playing;

  Future<List> readJson() async {
    final String response = await rootBundle.loadString(languageGameFourPath);
    final data = await json.decode(response);

    return data["languageGame4"];
  }

  // Question handler
  void nextQuestion() {
    if (_currentQuestion >= _wordsList.length - 1) return;

    increaseQuestionNumber();
    changeQuestionWord();
    changeSolutionWord();
    resetAnswer();
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

      if (index < _currentAnswerPosition) {
        _currentAnswerPosition = index;
      }
    });
  }

  void checkAnswer() {
    print(_solutionWord);
    print(_answerWord);

    if (listEquals(_solutionWord, _answerWord)) {
      print("Correct");
      setState(() {
        _point += 20;
      });
    }
    ;
  }

  void changeStatus(GameStatus status) {
    if (status == GameStatus.checking) setCancelTimer();

    setState(() {
      _status = status;
    });
  }

  // Timer Handler
  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = questionDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        setCancelTimer();
      } else {
        questionDuration = Duration(seconds: seconds);
      }
    });
  }

  void setCancelTimer() {
    countdownTimer!.cancel();
    setState(() {
      _status = GameStatus.checking;
    });
    print("Time's up");
  }

  @override
  void initState() {
    super.initState();
    readJson().then((wordsList) {
      // Shuffle the questions list
      wordsList.shuffle();
      setState(() {
        _wordsList = wordsList;
      });

      changeQuestionWord();
      changeSolutionWord();
      resetAnswer();
      startTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = questionDuration.inSeconds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Game Four'),
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
            onPressed: () => {handleClickCheck()},
            child: const Text("Kiểm tra", style: TextStyle(fontSize: 24)),
          )
        ])),
      ),
    );
  }

  Column wordButtonWidget(List<String> wordList, ButtonType type) {
    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: wordList
              .asMap()
              .entries
              .map((entry) => buttonCharacter(entry.key, entry.value, type))
              .toList()),
    ]);
  }

  Expanded buttonCharacter(int index, String char, ButtonType type) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.all(4),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size.fromHeight(70)),
                onPressed: () {
                  if (_status == GameStatus.checking) return;
                  if (char == "") return;
                  switch (type) {
                    case ButtonType.question:
                      selectAnswer(char, index);
                      break;
                    case ButtonType.answer:
                      deleteAnswer(char, index);
                      break;
                    default:
                      break;
                  }
                },
                child: Text(char, style: const TextStyle(fontSize: 30)))));
  }
}
