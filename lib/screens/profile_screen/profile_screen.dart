import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  dynamic currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('${currentUser?.photoUrl}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Text(
                  '${currentUser?.displayName}',
                  style: TextStyle(
                      color: darkTextColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '${currentUser?.email}',
                    style: TextStyle(
                        color: darkTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ]),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 50, bottom: 20),
              child: OutlinedButton(
                onPressed: () => _handleSignOut(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  fixedSize: Size(360, 40),
                  backgroundColor: primaryOrange,
                  side: BorderSide(
                    color: Colors.transparent,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text(
                  'Đăng Xuất',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
