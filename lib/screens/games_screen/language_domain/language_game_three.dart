import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math';
import 'package:brain_training/constants/enum.dart';
import 'package:brain_training/constants/base_url.dart';
import 'package:brain_training/constants/color.dart';
import 'package:brain_training/utils/toast.dart';
import 'package:brain_training/utils/custom_dialog.dart';
import 'package:brain_training/widget/clock.dart';

class LanguageGameThree extends StatefulWidget {
  const LanguageGameThree({super.key});

  @override
  State<LanguageGameThree> createState() => _LanguageGameThreeState();
}

class _LanguageGameThreeState extends State<LanguageGameThree> {
  final int answerDurationInSeconds = 60;
  final int pointPerCorrectAnswer = 200;

  Duration answerDuration = const Duration();
  Timer? countdownTimer;
  late Toast toast;
  late CustomDialog dialog;

  TextEditingController controller = TextEditingController();
  late Future<String> firstCharacter;
  List<String> _answer = [];
  int _point = 0;
  GameStatus _status = GameStatus.playing;

  List<String> dataList = [];
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
        changeStatus(GameStatus.end);
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
    final response = await http.get(dictionaryUrl);
    final data = response.body;
    dataList = data.toLowerCase().split('\n');

    if (dataList.isNotEmpty) {
      String firstCharacter =
          dataList[Random().nextInt(dataList.length)].split(' ')[0];
      _answer.add(firstCharacter);
      return firstCharacter;
    }

    throw Exception('Failed to load random character in the dictionary');
  }

  Future<bool> checkValidWord(String word) async {
    Map<String, String> headers = {'Content-type': 'application/json'};
    final response = await http.post(Uri.parse('$baseUrlLanguage/check'),
        headers: headers, body: jsonEncode({'text': word}));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // Logic Handler
  void handleClickCheck() async {
    String userAnswer = controller.text;
    String firstChar = _answer.last;
    String checkingWord = '$firstChar $userAnswer';

    bool isValidWord = await checkValidWord(checkingWord);
    if (isValidWord) {
      toast.show('Chính xác', Color.fromRGBO(107, 174, 68, 1));
      _answer.add(userAnswer);
      setState(() {
        _point += pointPerCorrectAnswer;
        // Restart timer
        answerDuration = Duration(seconds: answerDurationInSeconds);
      });
    } else {
      toast.show('Sai rồi!', Color.fromRGBO(234, 67, 53, 1));
    }

    controller.text = '';
  }

  void changeStatus(GameStatus status) {
    handleStatusChange(status);

    setState(() {
      _status = status;
    });
  }

  void restartGame() {
    _answer = [];
    _answer.add(dataList[Random().nextInt(dataList.length)].split(' ')[0]);
    controller.text = '';
    setState(() {
      _point = 0;
      _status = GameStatus.playing;
    });
    startTimer();
  }

  void handleStatusChange(GameStatus status) {
    if (status == GameStatus.end) {
      dialog.show(
          Text("Kết Thúc",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                  fontWeight: FontWeight.w600)),
          SingleChildScrollView(
              child: ListBody(children: <Widget>[
            Text("Tổng điểm: $_point",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 5),
          ])),
          [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.only(left: 50, right: 50),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: orangePastel,
              ),
              child: TextButton(
                child: const Text("Chơi lại",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                  restartGame();
                },
              ),
            )
          ]);
    }
  }

  @override
  void initState() {
    super.initState();

    toast = Toast(context: context);
    dialog = CustomDialog(context: context);
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
        foregroundColor: Color.fromRGBO(89, 70, 61, 1),
        title: const Text(
          'Trò chơi nối chữ',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color.fromRGBO(251, 222, 172, 1),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder<String>(
        future: firstCharacter,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 15),
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
                height: 34,
              ),
              const Text(
                  'Hãy điền tiếng tiếp theo để tạo nên một cụm từ có nghĩa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: darkTextColor)),
              const SizedBox(
                height: 60,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                    width: 180,
                    height: 120,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(246, 204, 131, 1),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    alignment: Alignment.center,
                    child: Text(_answer.last,
                        style: const TextStyle(
                            fontSize: 34,
                            color: Color.fromRGBO(89, 70, 61, 1),
                            fontWeight: FontWeight.w700))),
                Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(251, 222, 172, 1),
                        border: Border.all(
                            color: Color.fromRGBO(247, 202, 22, 1), width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    width: 180,
                    height: 120,
                    alignment: Alignment.center,
                    child: TextField(
                      enabled: _status == GameStatus.playing,
                      controller: controller,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 34,
                          color: Color.fromRGBO(89, 70, 61, 1),
                          fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: InputBorder.none,
                        hintText: 'nhập từ',
                        hintStyle: TextStyle(
                            fontSize: 34,
                            color: Color.fromRGBO(89, 70, 61, 0.62),
                            fontWeight: FontWeight.w400),
                      ),
                    ))
              ]),
              const SizedBox(
                height: 120,
              ),
              _status == GameStatus.playing
                  ? ElevatedButton(
                      onPressed: controller.text.isNotEmpty
                          ? () => handleClickCheck()
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(180, 211, 161, 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 24)),
                      child: const Text('Kiểm tra',
                          style: TextStyle(
                              fontSize: 22,
                              color: Color.fromRGBO(89, 70, 61, 1),
                              fontWeight: FontWeight.w600)),
                    )
                  : Container()
            ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const Center(
              heightFactor: 22.0, child: CircularProgressIndicator());
        },
      )),
    );
  }
}
