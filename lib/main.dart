import 'package:brain_training/screens/main_menu/MainMenu.dart';
import 'package:brain_training/screens/profile_screen/profile_screen.dart';
import 'package:brain_training/screens/ranking_screen/ranking_screen.dart';
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
  dynamic dataUser;

  MyHomePage({super.key, required this.title, required this.dataUser});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = [MainMenu(), RankingScreen(), ProfileScreen()];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNav(
        colorBackground: primaryOrange,
        colorSelectedItem: Colors.black,
        colorUnselectedItem: Colors.white,
        function: (int index) => _onItemTapped(index),
        selectedIndex: selectedIndex,
      ),
    );
  }
}
