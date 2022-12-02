import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Game1 extends StatefulWidget {
  const Game1({super.key});

  @override
  State<Game1> createState() => _Game1State();
}

class _Game1State extends State<Game1> {
  String listChar = "lib/constants/language-1.json";
  String starterChar = "";
  String wordInput = "";
  int statusCode = 0;
  int score = 0;
  int currentIndex = 0;
  List charList = [];
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 119);
  TextEditingController controllerInput = TextEditingController();
  final String endpointUrl = Platform.isAndroid
      ? 'http://192.168.1.2:5001/api/language'
      : 'http://localhost:5001/api/language';

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
    controllerInput.dispose();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
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
    _showMyDialog("Kết thúc", "Điểm: $score", () {
      Navigator.of(context).pop();
      setState(() {
        myDuration = const Duration(seconds: 119);
        score = 0;
        currentIndex = Random().nextInt(charList.length);
        starterChar = charList[currentIndex];
        wordInput = "";
        controllerInput.clear();
        startTimer();
      });
    });
  }

  Future<bool> checkValidWord(String value) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(Uri.parse("$endpointUrl/check"),
        headers: headers, body: jsonEncode({"text": value}));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString(listChar);
    final data = await json.decode(response);
    currentIndex = Random().nextInt(data["character"].length);
    setState(() {
      starterChar = data["character"][currentIndex];
      charList = data["character"];
    });
  }

  void handleClickCheck() async {
    String userAnswer = controllerInput.text;
    String checkingWord = "$starterChar$userAnswer";
    bool isValidWord = await checkValidWord(checkingWord);
    if (isValidWord) {
      currentIndex = Random().nextInt(charList.length);
      starterChar = charList[currentIndex];
      if (wordInput.length == 2) {
        setState(() {
          score += 200;
        });
      } else if (wordInput.length == 3) {
        setState(() {
          score += 300;
        });
      } else if (wordInput.length == 4) {
        setState(() {
          score += 300;
        });
      } else if (wordInput.length == 5) {
        setState(() {
          score += 500;
        });
      } else if (wordInput.length == 6) {
        setState(() {
          score += 600;
        });
      } else if (wordInput.length == 7) {
        setState(() {
          score += 700;
        });
      }
    }
    setState(() {
      controllerInput.clear();
      wordInput = "";
    });
  }

  void handleCheckResult() {
    if (wordInput.isNotEmpty && wordInput.length >= 2) {
      handleClickCheck();
    } else {
      _showMyDialog("Thông báo", "Nhập ít nhất 2 ký tự", () {
        setState(() {
          Navigator.of(context).pop();
          wordInput = "";
          controllerInput.clear();
        });
      });
    }
  }

  Future<void> _showMyDialog(
      String title, String content, Function callback) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
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
                  child: const Text('Chơi lại'),
                  onPressed: () => callback(),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tìm từ hợp lệ'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                ),
                child: Text("Thời gian còn lại: ${myDuration.inSeconds}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 30)),
              ),
              Text("Điểm: $score",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20)),
              const Padding(
                padding: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                ),
                child: Text("Tìm chữ/từ thích hợp bắt đầu bằng:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                    wordInput == ""
                        ? "$starterChar _____"
                        : "$starterChar$wordInput",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 30)),
              ),
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: TextField(
                    controller: controllerInput,
                    textAlign: TextAlign.center,
                    onChanged: (text) {
                      setState(() {
                        wordInput = text;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      hintText: "Nhập chữ cái thích hợp",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: ElevatedButton(
                    onPressed: () {
                      handleCheckResult();
                    },
                    child: const Text("Kiểm tra")),
              ),
            ],
          ),
        ));
  }
}
