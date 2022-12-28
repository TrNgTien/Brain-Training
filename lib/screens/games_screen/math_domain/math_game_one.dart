import 'dart:async';
import 'dart:convert';
import 'package:function_tree/function_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brain_training/constants/color.dart';
import 'package:brain_training/widget/clock.dart';
import 'package:brain_training/utils/custom_dialog.dart';

class MathGame extends StatefulWidget {
  MathGame({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MathGame> createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  Timer? countdownTimer;
  String mathGamePath = "lib/constants/math_game.json";
  Duration myDuration = const Duration(seconds: 59);
  late CustomDialog dialog;
  List _items = [];
  int _currentPlace = 0;
  int _point = 0;
  int _numOfCorrect = 0;
  bool isEnd = false;
  bool _visible = false;
  bool isAdd = true;
  int number = 0;

  @override
  void initState() {
    super.initState();
    dialog = CustomDialog(context: context);
    readJson();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    countdownTimer!.cancel();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString(mathGamePath);
    final data = await json.decode(response);
    setState(() {
      _currentPlace = data["currentPlace"];
      _items = data["mathGame1"];
    });
  }

  void updateCurrentPlace() {
    if (_currentPlace >= _items.length - 1) return;

    setState(() {
      _currentPlace++;
    });
  }

  void handleClickAns(String selected) {
    handleAns(selected);

    updateCurrentPlace();
  }

  void handleAns(String selected) {
    if (validateAns(selected)) {
      _point += int.parse(_items[_currentPlace]["points"]);
      _numOfCorrect++;
      if (_numOfCorrect == 5) {
        addTimer();
        setState(() {
          _visible = true;
          isAdd = true;
          number = 10;
        });
      }
      ;
    } else {
      _numOfCorrect = 0;

      minusTimer();
      setState(() {
        _visible = false;
        isAdd = false;
        number = 2;
      });
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _visible = false;
      });
    });
  }

  bool validateAns(String selected) {
    String leftExp = _items[_currentPlace]["leftExpressions"];
    String rightExp = _items[_currentPlace]["rightExpressions"];
    if (selected == "leftExpressions") {
      return leftExp.interpret() < rightExp.interpret();
    } else {
      return leftExp.interpret() > rightExp.interpret();
    }
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
        isEnd = true;
      } else {
        myDuration = Duration(seconds: myDuration.inSeconds - 2);
      }
    });
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        setCancelTimer();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  void setCancelTimer() {
    countdownTimer!.cancel();
    dialog.show(
        Text("Kết Thúc",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.red, fontSize: 40, fontWeight: FontWeight.w600)),
        Text(
          "Hết giờ",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        [
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
              onPressed: () {
                setState(() {
                  myDuration = const Duration(seconds: 59);
                  _items = [];
                  _currentPlace = 0;
                  _point = 0;
                  _numOfCorrect = 0;
                  isEnd = false;
                  _visible = false;
                  isAdd = true;
                  number = 0;
                  readJson();
                  startTimer();
                });
                Navigator.of(context).pop();
              },
            ),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final seconds = myDuration.inSeconds;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePastel,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Clock(seconds: seconds),
                  animateClock(isAdd, number)
                ],
              ),
            ),
            Text("Điểm: $_point",
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: brownColor,
                    fontSize: 30)),
            const Padding(
              padding: EdgeInsets.only(
                top: 30,
                bottom: 20,
              ),
              child: Text("Chọn đáp án có kết quả nhỏ hơn",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20)),
            ),
            const SizedBox(
              height: 30,
            ),
            _items.isEmpty ? Container() : answers(),
          ],
        ),
      ),
    );
  }

  Row answers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buttonAns("leftExpressions"),
        const SizedBox(
          width: 2,
        ),
        buttonAns("rightExpressions")
      ],
    );
  }

  Widget animateClock(bool isAdd, int number) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      // The green box must be a child of the AnimatedOpacity widget.
      child: Text(
        '${isAdd ? '+' : '-'} $number',
        style: TextStyle(color: isAdd ? Colors.green : Colors.red),
      ),
    );
  }

  Expanded buttonAns(String ansSide) {
    return Expanded(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromHeight(150),
              backgroundColor: orangePastel),
          onPressed: () => isEnd ? null : handleClickAns(ansSide),
          child: Text(
            _items[_currentPlace][ansSide],
            style: const TextStyle(
              fontSize: 19,
              color: darkTextColor,
            ),
          )),
    );
  }
}
