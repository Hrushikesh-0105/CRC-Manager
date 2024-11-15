import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:crc_app/pages/choose_user_page.dart';
import 'package:crc_app/pages/floors_page.dart';
import 'package:crc_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget nextScreenToNavigate = ChooseUserPage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    // double deviceHeight = MediaQuery.of(context).size.height;
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Center(
              child: LottieBuilder.asset(
                "assets/lottie/newCalandarAnimation.json",
                height: 200,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: deviceWidth,
            child: Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('CRC Manager',
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: prussianBlue,
                          fontSize: 30.0),
                      speed: const Duration(milliseconds: 150)),
                ],
              ),
            ),
          ),
        ],
      ),
      nextScreen: nextScreenToNavigate,
      splashIconSize: 400,
      backgroundColor: Colors.white,
      duration: 2000,
    );
  }

  Future<void> _checkPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasValue =
        prefs.containsKey('User'); // Replace 'yourKey' with the actual key

    // Update the next screen based on whether the value exists
    setState(() {
      nextScreenToNavigate = hasValue ? FloorsPage() : ChooseUserPage();
    });
  }
}
