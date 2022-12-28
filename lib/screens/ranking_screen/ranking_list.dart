import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';

class RankingList extends StatelessWidget {
  final String domainName;

  RankingList({super.key, required this.domainName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bảng xếp hạng"),
          backgroundColor: primaryOrange,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              height: 50,
              color: Colors.amber[600],
              child: const Center(child: Text('Trò A')),
            ),
            Container(
              height: 50,
              color: Colors.amber[500],
              child: const Center(child: Text('Trò B')),
            ),
            Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Trò C')),
            ),
          ],
        ));
  }
}
