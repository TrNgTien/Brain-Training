import 'package:flutter/material.dart';

class LogoApp extends StatelessWidget {
  const LogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    String logoPath = 'lib/assets/images/logo-transparent.png';
    return Image.asset(
      logoPath,
      width: 600.0,
      height: 240.0,
      fit: BoxFit.cover,
    );
  }
}
