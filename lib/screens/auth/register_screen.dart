import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:brain_training/main.dart';

import '../../widget/logo_app.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    const facebookIcon = 'lib/assets/icons/facebook_ic.svg';
    const googleIcon = 'lib/assets/icons/google_ic.svg';
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryBackground,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
            child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Đăng kí tài khoản",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      color: primaryOrange,
                      fontWeight: FontWeight.w700,
                    )),
                LogoApp(),
                Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const MyHomePage(
                                    title: "Brain Training",
                                  ),
                              fullscreenDialog: true));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: blueFbBtn,
                            boxShadow: const [
                              BoxShadow(color: blueFbBtn, spreadRadius: 10),
                            ],
                          ),
                          height: 50,
                          width: 250,
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              facebookIcon,
                              height: 30,
                              width: 30,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Tài khoản Facebook",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                        )),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const MyHomePage(
                                    title: "Brain Training",
                                  ),
                              fullscreenDialog: true));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 40, bottom: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: redGgBtn,
                            boxShadow: const [
                              BoxShadow(color: redGgBtn, spreadRadius: 10),
                            ],
                          ),
                          height: 50,
                          width: 250,
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              googleIcon,
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Tài khoản Google",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                        )),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Nếu bạn đã có tài khoản.",
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: darkTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Đăng nhập tại đây!",
                          style: TextStyle(
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            color: primaryOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ]),
        )));
  }
}
