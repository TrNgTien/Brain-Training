import 'dart:convert' show json;
import 'package:brain_training/widget/logo_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:brain_training/constants/color.dart';
import 'package:brain_training/main.dart';
import "package:brain_training/constants/icons.dart";
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  dynamic currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      dynamic dataUser = await _googleSignIn.signIn();
      setState(() {
        currentUser = dataUser;
      });
      Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (ctx) => MyHomePage(
                title: "Brain Training",
                dataUser: dataUser,
              ),
          fullscreenDialog: true));
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
                          _handleSignIn();
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
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ]),
                        )),
                  ],
                ),
              ]),
        )));
  }
}
