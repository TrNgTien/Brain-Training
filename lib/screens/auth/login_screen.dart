import 'dart:convert' show json;
import 'package:brain_training/screens/auth/register_screen.dart';
import 'package:brain_training/widget/logo_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:brain_training/constants/color.dart';
import 'package:brain_training/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const facebookIcon = 'lib/assets/icons/facebook_ic.svg';
    const googleIcon = 'lib/assets/icons/google_ic.svg';

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryBackground,
        ),
        body: SafeArea(
            child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Đăng nhập",
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
                      "Nếu bạn chưa có tài khoản?",
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const RegisterScreen(),
                              fullscreenDialog: true));
                        },
                        child: const Text(
                          "Tạo tài khoản",
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
