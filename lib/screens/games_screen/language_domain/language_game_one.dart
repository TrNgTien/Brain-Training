import 'dart:math';
import 'package:brain_training/constants/color.dart';
import 'package:brain_training/widget/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:brain_training/utils/custom_dialog.dart';
import 'package:brain_training/utils/toast.dart';

class LanguageGameOne extends StatefulWidget {
  const LanguageGameOne({super.key});

  @override
  State<LanguageGameOne> createState() => _LanguageGameOneState();
}

class _LanguageGameOneState extends State<LanguageGameOne> {
  String starterChar = "";
  String wordInput = "";
  int statusCode = 0;
  int score = 0;
  int currentIndex = 0;
  List charList = [];
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 299);
  TextEditingController controllerInput = TextEditingController();
  final String endpointUrl = 'https://mobile.iuweb.online/api/language';
  String listChar = "lib/constants/language_1.json";
  late CustomDialog dialog;
  late Toast toast;

  @override
  void initState() {
    super.initState();
    toast = Toast(context: context);
    dialog = CustomDialog(context: context);
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
    dialog.show(
        Text("Kết Thúc",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.red, fontSize: 40, fontWeight: FontWeight.w600)),
        SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                "Điểm: $score",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
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
                Navigator.of(context).pop();
                setState(() {
                  myDuration = const Duration(seconds: 299);
                  score = 0;
                  currentIndex = Random().nextInt(charList.length);
                  starterChar = charList[currentIndex];
                  wordInput = "";
                  controllerInput.clear();
                  startTimer();
                });
              },
            ),
          )
        ]);
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
      toast.show('Chính xác, tiếp tục nào!!', Colors.green);
      if (checkingWord.length == 2) {
        setState(() {
          score += 200;
        });
      } else if (checkingWord.length == 3) {
        setState(() {
          score += 300;
        });
      } else if (checkingWord.length == 4) {
        setState(() {
          score += 400;
        });
      } else if (checkingWord.length == 5) {
        setState(() {
          score += 500;
        });
      } else if (checkingWord.length == 6) {
        setState(() {
          score += 600;
        });
      } else if (checkingWord.length == 7) {
        setState(() {
          score += 700;
        });
      }
    } else {
      toast.show('Không hợp lệ', Colors.red);
    }
    setState(() {
      controllerInput.clear();
      wordInput = "";
    });
  }

  void handleCheckResult() {
    if (wordInput.isNotEmpty) {
      handleClickCheck();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tìm từ hợp lệ'),
          backgroundColor: primaryOrange,
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Clock(seconds: myDuration.inSeconds),
                    Text(" (5 phút)",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20)),
                  ],
                ),
              ),
              Text("Điểm: $score",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: brownColor,
                      fontSize: 30)),
              const Padding(
                padding: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
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
                        fontWeight: FontWeight.w700,
                        color: brownColor,
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
                        borderSide: const BorderSide(
                          color: brownColor,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: const BorderSide(
                          color: brownColor,
                        ),
                      ),
                      hintText: "Nhập chữ cái thích hợp",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Container(
                    child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    color: grayColor,
                  ),
                  child: TextButton(
                    child: const Text('Kiểm tra',
                        style: TextStyle(fontSize: 20, color: darkTextColor)),
                    onPressed: () => handleCheckResult(),
                  ),
                )),
              ),
            ],
          ),
        )));
  }
}
