import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';

class LanguageGameThree extends StatefulWidget {
  const LanguageGameThree({super.key});

  @override
  State<LanguageGameThree> createState() => _LanguageGameThreeState();
}

class _LanguageGameThreeState extends State<LanguageGameThree> {
  final String url = Platform.isAndroid
      ? 'http://192.168.1.2:8080/api/language'
      : 'http://localhost:8080/api/language';
  final int answerDurationInSeconds = 60;
  Duration answerDuration = const Duration();
  Timer? countdownTimer;

  TextEditingController controller = TextEditingController();
  late Future<String> firstCharacter;
  List<String> _answer = [];
  int _point = 0;

  // Timer Handler
  void startTimer() {
    answerDuration = Duration(seconds: answerDurationInSeconds);

    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = answerDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        setCancelTimer();
      } else {
        answerDuration = Duration(seconds: seconds);
      }
    });
  }

  void setCancelTimer() {
    countdownTimer!.cancel();
  }

  // Fetch Data
  Future<String> fetchRandomCharacter() async {
    final response = await http.get(Uri.parse("$url/word"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String firstCharacter = data["word"].split(" ")[0];
      _answer.add(firstCharacter);
      return firstCharacter;
    }

    throw Exception('Failed to load album');
  }

  Future<bool> checkValidWord(String word) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(Uri.parse("$url/check"),
        headers: headers, body: jsonEncode({"text": word}));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // Logic Handler
  void handleClickCheck() async {
    String userAnswer = controller.text;
    String firstChar = _answer.last;
    String checkingWord = "$firstChar $userAnswer";

    bool isValidWord = await checkValidWord(checkingWord);
    if (isValidWord) {
      _answer.add(userAnswer);
      setState(() {
        _point += 200;
      });
    }

    controller.text = "";
  }

  @override
  void initState() {
    super.initState();

    firstCharacter = fetchRandomCharacter();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    setCancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = answerDuration.inSeconds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Game Three'),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder<String>(
        future: firstCharacter,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: [
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
              const Text("Hãy điền tiếng tiếp theo để tạo nên một từ có nghĩa",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
              const SizedBox(
                height: 60,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                    color: Colors.blue[600],
                    width: 180,
                    height: 120,
                    alignment: Alignment.center,
                    child: Text(_answer.last,
                        style: const TextStyle(
                            fontSize: 30, color: Colors.white))),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2)),
                    width: 180,
                    height: 120,
                    alignment: Alignment.center,
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: InputBorder.none,
                        hintText: "Nhập từ",
                      ),
                    ))
              ]),
              const SizedBox(
                height: 120,
              ),
              ElevatedButton(
                onPressed: () => handleClickCheck(),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    textStyle: const TextStyle(fontSize: 24)),
                child: const Text("Kiểm tra"),
              )
            ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      )),
    );
  }
}
