import 'package:brain_training/screens/game_list.dart';
import 'package:brain_training/widget/splash_screen.dart';
import 'package:flutter/material.dart';
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
  List listDomain = ["Trí nhớ", "Nhận thức", "Ngôn ngữ", "Toán học"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: orangePastel,
        foregroundColor: darkTextColor,
        titleTextStyle: const TextStyle(
          color: darkTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(
                bottom: 30,
              ),
              child: Text("Chọn lĩnh vực trò chơi",
                  style: TextStyle(
                    fontSize: 35,
                    color: primaryOrange,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            gridDomain(listDomain, context),
          ],
        ),
      ),
    );
  }
}

GridView gridDomain(List listDomain, BuildContext context) {
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

  return GridView.builder(
      shrinkWrap: true,
      itemCount: 4,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (_, int index) {
        return InkWell(
            onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          GameList(domainName: listDomain[index])))
                },
            child: GridTile(
                child: Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      color: backgroundColor(listDomain[index]),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text("${listDomain[index]}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: darkTextColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              )),
                        )))));
      });
}
