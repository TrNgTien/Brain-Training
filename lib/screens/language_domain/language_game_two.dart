import 'package:flutter/material.dart';

class LanguageGameTwo extends StatefulWidget {
  const LanguageGameTwo({Key? key}) : super(key: key);

  @override
  State<LanguageGameTwo> createState() => _LanguageGameTwoState();
}

class _LanguageGameTwoState extends State<LanguageGameTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: const [Text("data"), Text("data")],
        ),
      ),
    );
  }
}
