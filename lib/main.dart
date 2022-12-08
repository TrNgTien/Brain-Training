import 'package:brain_training/widget/grid_game.dart';
import 'package:flutter/material.dart';
import 'package:brain_training/widget/bottom_nav.dart';
import 'package:brain_training/widget/splash_screen.dart';
import 'package:brain_training/constants/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Training',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: primaryBackground,
      ),
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> listDomain = ["Trí nhớ", "Nhận thức", "Ngôn ngữ", "Toán học"];
  String playingIcon = "lib/assets/icons/playing_ic.svg";
  String profileIcon = "lib/assets/icons/profile_ic.svg";
  String rankingIcon = "lib/assets/icons/ranking_ic.svg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: primaryOrange,
          automaticallyImplyLeading: false,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Chọn lĩnh vực trò chơi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    color: primaryOrange,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(
                height: 40,
              ),
              GridGame(
                listDomain: listDomain,
                context: context,
                typeView: 'playing',
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNav(
          colorBackground: primaryOrange,
          colorSelectedItem: Colors.black,
          colorUnselectedItem: Colors.white,
        ));
  }
}
