import 'dart:async';
import 'dart:convert';
import 'package:function_tree/function_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MathGame extends StatefulWidget {
  const MathGame({Key? key}) : super(key: key);

  @override
  State<MathGame> createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 60);
  List _items = [];
  int _currentPlace = 0;
  int _point = 0;
  int _numOfCorrect = 0;
  String GAME_RULES =
      "Người chơi chọn vào phép tính có kết quả bé nhất\nThời gian: 60 giây\nTrả lời đúng 5 câu liên tiếp -> cộng thêm 10s\nSai: -2s/ đáp án\nSố điểm cho từng round đã được để trong excel\nTổng điểm = Tổng điểm mỗi round";

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/math_game.json');
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

  void handleOnclickAns(String selected) {
    handleAns(selected);

    updateCurrentPlace();
  }

  void handleAns(String selected) {
    if (validateAns(selected)) {
      _point += int.parse(_items[_currentPlace]["points"]);
      _numOfCorrect++;
      if (_numOfCorrect == 5) addTimer();
    } else {
      _numOfCorrect = 0;
      minusTimer();
    }
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
    _showMyDialog("Kết thúc", "Hết giờ", () {
      Navigator.of(context).pop();
    });
  }

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
              "Điểm: $_point",
              style: const TextStyle(fontSize: 30, color: Colors.red),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Chọn đáp án có kết quả nhỏ hơn",
              style: TextStyle(fontSize: 25),
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

  Expanded buttonAns(String ansSide) {
    return Expanded(
      child: ElevatedButton(
          style:
              ElevatedButton.styleFrom(fixedSize: const Size.fromHeight(150)),
          onPressed: () => handleOnclickAns(ansSide),
          child: Text(
            _items[_currentPlace][ansSide],
            style: const TextStyle(fontSize: 19),
          )),
    );
  }

  Future<void> _showMyDialog(
      String title, String content, Function callback) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
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
