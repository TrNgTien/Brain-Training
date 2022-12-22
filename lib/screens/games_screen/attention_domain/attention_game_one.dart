import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brain_training/utils/helper.dart';
import 'package:brain_training/constants/color.dart';
import 'package:brain_training/widget/clock.dart';

class AttentionGameOne extends StatefulWidget {
  const AttentionGameOne({super.key});

  @override
  State<AttentionGameOne> createState() => _AttentionGameOneState();
}

class _AttentionGameOneState extends State<AttentionGameOne> {
  String ATTENTION_GAME_1_PATH = "lib/constants/attention_game_1.json";
  String ATTENTION_KEY = "attentionData";

  List<String> imagesAssetPath = [];
  List<String> solutionAssetPath = [];
  List gameData = [];
  int currentQuestion = 0;
  late int currentKey;

  int getCurrentDataIndex(String imageName) {
    String key = imageName.split("/").last.split(".").first;
    return int.parse(key) - 1;
  }

  Future<void> _initImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Load Path
    final solutionImagePath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Attention/'))
        .where((String key) => key.contains('Solution/'))
        .where((String key) => key.contains('28.png'))
        .toList();

    final attentionImagePath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Attention/'))
        .where((String key) => key.contains('Question/'))
        .where((String key) => key.contains('28.png'))
        .toList();
    attentionImagePath.shuffle();

    setState(() {
      solutionAssetPath = solutionImagePath;
      imagesAssetPath = attentionImagePath;
      currentKey = getCurrentDataIndex(imagesAssetPath[0]);
    });
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    double boxHeight = MediaQuery.of(context).size.height * 0.5;
    double boxWidth = MediaQuery.of(context).size.width;
    print('${details.localPosition}');

    // double posx = details.globalPosition.dx;
    // double posy = details.globalPosition.dy;
    double resultX = gameData[currentKey]["result"]["x"] * boxHeight;
    double resultY = gameData[currentKey]["result"]["y"] * boxWidth;
    print('Result: $resultX, $resultY');
  }

  @override
  void initState() {
    super.initState();

    _initImages();
    readJson(ATTENTION_GAME_1_PATH, ATTENTION_KEY).then((imageData) => {
          setState(() {
            gameData = imageData;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hãy tìm vị trí đúng theo yêu cầu"),
          backgroundColor: pinkPastel,
          titleTextStyle: const TextStyle(
            color: darkTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                "Điểm: 0",
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: primaryOrange,
                    fontSize: 35),
              ),
            ),
            Clock(seconds: 120),
            SizedBox(height: 30),
            Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: imagesAssetPath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                            child: GestureDetector(
                                onTapDown: (TapDownDetails details) =>
                                    onTapDown(context, details),
                                child: Ink.image(
                                  image: AssetImage(
                                      imagesAssetPath[currentQuestion]),
                                  fit: BoxFit.scaleDown,
                                  child: InkWell(
                                    onTap: () {},
                                  ),
                                ))))
                    : Container())
          ],
        ));
  }
}
