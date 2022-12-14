import 'package:brain_training/screens/ranking_screen/ranking_list.dart';
import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:brain_training/constants/icons.dart";
import 'package:brain_training/screens/game_list.dart';

class GridGame extends StatelessWidget {
  final context;
  final String typeView;
  final List<String> listDomain;

  GridGame(
      {super.key,
      required this.listDomain,
      required this.context,
      required this.typeView});

  @override
  Widget build(BuildContext context) {
    return gridDomain(listDomain, context);
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
                    if (typeView != 'ranking')
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              GameList(domainName: listDomain[index])))
                    else
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RankingList(domainName: listDomain[index])))
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
}
