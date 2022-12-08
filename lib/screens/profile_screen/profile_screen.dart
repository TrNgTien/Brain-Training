import 'package:flutter/material.dart';
import 'package:brain_training/constants/color.dart';
import 'package:brain_training/widget/bottom_nav.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tài khoản của tôi"),
          backgroundColor: primaryOrange,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        body: Container(
          child: Text("Profile"),
        ),
        bottomNavigationBar: BottomNav(
          colorBackground: primaryOrange,
          colorSelectedItem: Colors.black,
          colorUnselectedItem: Colors.white,
        ));
  }
}
