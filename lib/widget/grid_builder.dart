import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';
import 'dart:math';

class GridBuilder extends StatefulWidget {
  int numberItems;
  int matrix;
  GridBuilder({super.key, required this.numberItems, required this.matrix});

  @override
  State<GridBuilder> createState() => _GridBuilderState();
}

class _GridBuilderState extends State<GridBuilder> {
  List<int> randomList = [];
  List<int> locations = [];
  List<int> correctLocations = [];
  int currentLevel = 1;
  bool correctLocation = false;
  dynamic chosenLocation;

  @override
  void initState() {
    super.initState();
    getRandomLocation();
    // Future.delayed(const Duration(
    //   seconds: 10,
    // )).then((_) {
    //   setState(() {
    //     randomList = [];
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    randomList.clear();
    locations.clear();
  }

  void getRandomLocation() {
    var rng = Random();
    for (var i = 0; i <= widget.matrix; i++) {
      setState(() {
        randomList.add(rng.nextInt(widget.numberItems));
        locations = randomList;
      });
    }
  }

  void handleCheckLocation(int index) {
    chosenLocation = index;
    if (locations.contains(index)) {
      setState(() {
        correctLocations.add(index);
        correctLocation = true;
      });
    } else {
      setState(() {
        correctLocation = false;
      });
    }
  }

  Color? validateLocation(int index) {
    if (randomList.contains(index) &&
        index != chosenLocation &&
        !correctLocation) {
      return Colors.yellow;
    } else if (locations.contains(chosenLocation) &&
        correctLocations.contains(index) &&
        correctLocation) {
      return Colors.green;
    } else if (!locations.contains(chosenLocation) &&
        !correctLocation &&
        index == chosenLocation) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: widget.numberItems,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.matrix),
        itemBuilder: (_, int indexGrid) {
          return GestureDetector(
              onTap: () => handleCheckLocation(indexGrid),
              child: GridTile(
                  child: Container(
                decoration: BoxDecoration(
                    color: validateLocation(indexGrid),
                    // borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(color: greenPastel)),
              )));
        });
  }
}
