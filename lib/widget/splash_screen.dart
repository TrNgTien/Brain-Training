import 'package:brain_training/screens/auth/login_screen.dart';
import 'package:brain_training/widget/logo_app.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:brain_training/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  dynamic currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(
      seconds: 2,
    )).then((value) {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (ctx) => const LoginScreen()));
    });
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account == null) {
        print("check account: $account");
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (ctx) => const LoginScreen()));
      } else {
        Future.delayed(const Duration(
          seconds: 2,
        )).then((value) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MyHomePage(
                    title: "Brain Training",
                    dataUser: account,
                  ),
              fullscreenDialog: true));
        });
      }
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 0,
              ),
              child: const Text(
                "Brain Training",
                style: TextStyle(
                  fontSize: 40,
                  color: darkTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            LogoApp(),
            const SizedBox(
              height: 50,
            ),
            const SpinKitFadingCube(
              color: primaryOrange,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
