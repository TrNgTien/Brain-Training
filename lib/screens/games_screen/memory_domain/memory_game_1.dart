import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:brain_training/widget/clock.dart';
import 'package:brain_training/constants/color.dart';
import 'package:brain_training/utils/helper.dart';
import 'package:brain_training/utils/custom_dialog.dart';
import 'package:brain_training/utils/toast.dart';

class Game1 extends StatefulWidget {
  Game1({super.key, required this.titleGame});
  final String titleGame;

  @override
  State<Game1> createState() => _Game1State();
}

class _Game1State extends State<Game1> {
  final String jsonKey = "matrix";
  final String memory_game_1 = "lib/constants/memory_game_1.json";
  late CustomDialog dialog;
  late Toast toast;
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 2);
  bool correctLocation = false;
  bool isClickable = false;
  dynamic chosenLocation;
  List<int> randomList = [];
  List<int> locations = [];
  List matrixData = [];
  int score = 0;
  int currentLevel = 0;
  int secondsRun = 0;
  int errorTimes = 2;
  @override
  void initState() {
    super.initState();
    dialog = CustomDialog(context: context);
    toast = Toast(context: context);
    startTimer();
    readJson(memory_game_1, jsonKey).then((value) {
      setState(() {
        matrixData = value;
        generateRandomLocation(
            value[currentLevel]["vTile"], value[currentLevel]["hTile"]);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    randomList = [];
    locations = [];
    countdownTimer!.cancel();
  }

  void startTimer() {
    isClickable = false;
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    int reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      myDuration = Duration(seconds: 2);
      if (seconds < 0) {
        randomList = [];
        isClickable = true;
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  void handleCheckLocation(int index) {
    chosenLocation = index;
    if (locations.contains(index) && currentLevel < matrixData.length - 1) {
      setState(() {
        randomList = [];
        locations = [];
        currentLevel++;
        errorTimes = 2;
        score += 200;
        startTimer();
        generateRandomLocation(matrixData[currentLevel]["vTile"],
            matrixData[currentLevel]["hTile"]);
      });
    } else if (currentLevel < matrixData.length - 1) {
      if (currentLevel > 0 && errorTimes == 1) {
        setState(() {
          randomList = [];
          locations = [];
          errorTimes = 2;
          currentLevel--;
          startTimer();
          generateRandomLocation(matrixData[currentLevel]["vTile"],
              matrixData[currentLevel]["hTile"]);
        });
      } else if (errorTimes > 0) {
        setState(() {
          --errorTimes;
          toast.show('Bạn còn $errorTimes lần thử', Colors.red);
        });
      }
    } else {
      dialog.show(
          Text("Kết Thúc",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                  fontWeight: FontWeight.w600)),
          SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Tổng điểm: $score",
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
                  randomList = [];
                  locations = [];
                  errorTimes = 2;
                  currentLevel = 0;
                  Navigator.of(context).pop();
                  startTimer();
                },
              ),
            )
          ]);
    }
  }

  void generateRandomLocation(int vTile, int hTile) {
    var rng = Random();
    int amountOfTile = vTile * hTile;
    double gridTile = vTile * hTile * (1 / 3);
    int gridRounded = gridTile.round();
    for (int i = 0; i <= gridRounded - 1; i++) {
      int randomNumber = rng.nextInt(amountOfTile);
      if (!randomList.contains(randomNumber)) {
        setState(() {
          randomList.add(randomNumber);
          locations = randomList;
        });
      } else {
        int randomNumber = rng.nextInt(amountOfTile);
        setState(() {
          randomList.add(randomNumber);
          locations = randomList;
        });
      }
    }
  }

  Color? validateLocation(int index) {
    if (randomList.contains(index)) {
      return greenBtn;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleGame),
        backgroundColor: greenPastel,
        foregroundColor: darkTextColor,
        titleTextStyle: const TextStyle(
          color: darkTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    Text(
                      "Điểm: $score",
                      style: TextStyle(
                          color: primaryOrange,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                    if (matrixData.isNotEmpty)
                      Text(
                        "Cấp Độ: ${matrixData[currentLevel]["hTile"]} * ${matrixData[currentLevel]["vTile"]}",
                        style: TextStyle(
                            color: primaryOrange,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                  ]),
                  if (myDuration.inSeconds >= 0 && myDuration.inSeconds < 2)
                    Clock(seconds: myDuration.inSeconds),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                child: matrixMem(),
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget matrixMem() {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              matrixData.isNotEmpty ? matrixData[currentLevel]["hTile"] : 1,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: currentLevel == 0 ? 2 / 1 : 1 / 1,
        ),
        itemCount: matrixData.isNotEmpty
            ? matrixData[currentLevel]["vTile"] *
                matrixData[currentLevel]["hTile"]
            : 0,
        itemBuilder: (_, int indexGrid) {
          return GestureDetector(
              onTap: () {
                if (isClickable == true)
                  handleCheckLocation(indexGrid);
                else
                  return;
              },
              child: GridTile(
                  child: Container(
                decoration: BoxDecoration(
                    color: validateLocation(indexGrid),
                    // borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(color: greenBorder)),
              )));
        });
  }
}
