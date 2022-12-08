import 'package:brain_training/screens/game_list.dart';
import 'package:brain_training/widget/bottom_nav.dart';
import 'package:brain_training/widget/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  List listDomain = ["Trí nhớ", "Nhận thức", "Ngôn ngữ", "Toán học"];

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
              gridDomain(listDomain, context),
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

GridView gridDomain(List listDomain, BuildContext context) {
  String attentionIcon = "lib/assets/icons/attention_ic.svg";
  String languageIcon = "lib/assets/icons/language_ic.svg";
  String mathIcon = "lib/assets/icons/math_ic.svg";
  String memoryIcon = "lib/assets/icons/memory_ic.svg";
  Color? backgroundColor(String domainType) {
    switch (domainType) {
      case "Trí nhớ":
        return greenPastel;
      case "Nhận thức":
        return pinkPastel;
      case "Toán học":
        return orangePastel;
      case "Ngôn ngữ":
        return yellowPastel;
      default:
        return null;
    }
  }

  Widget IconDomain(String domainType) {
    switch (domainType) {
      case "Trí nhớ":
        return SvgPicture.asset(
          memoryIcon,
          height: 50,
          width: 50,
        );
      case "Nhận thức":
        return SvgPicture.asset(
          attentionIcon,
          height: 50,
          width: 50,
        );
      case "Toán học":
        return SvgPicture.asset(
          mathIcon,
          height: 50,
          width: 50,
        );
      case "Ngôn ngữ":
        return SvgPicture.asset(
          languageIcon,
          height: 50,
          width: 50,
        );
      default:
        return SvgPicture.asset(
          languageIcon,
          height: 50,
          width: 50,
        );
    }
  }

  return GridView.builder(
      shrinkWrap: true,
      itemCount: 4,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (_, int index) {
        return GestureDetector(
            onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          GameList(domainName: listDomain[index])))
                },
            child: GridTile(
                child: Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: backgroundColor(listDomain[index]),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconDomain(listDomain[index]),
                        Text("${listDomain[index]}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: darkTextColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    )))));
      });
}
