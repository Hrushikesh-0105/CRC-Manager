// import 'package:crc_app/pages/mode.dart';
// import 'package:crc_app/pages/mode.dart';
// import 'package:crc_app/pages/choose_user_page.dart';
import 'package:crc_app/pages/splash_screen.dart';
// import 'package:crc_app/pages/thirdPage.dart';
// import 'package:crc_app/pages/thirdPage.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'OpenSans',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
