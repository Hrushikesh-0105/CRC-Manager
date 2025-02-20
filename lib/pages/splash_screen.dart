import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crc_app/main.dart';
import 'package:crc_app/pages/choose_user_page.dart';
import 'package:crc_app/pages/floors_page.dart';
import 'package:crc_app/styles.dart';
import 'package:crc_app/userStatusProvider/user_and_event_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget _nextScreenToNavigate = const ChooseUserPage();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedSplashScreen.withScreenFunction(
            splash: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  "assets/lottie/newCalandarAnimation.json",
                  height: 200,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: deviceWidth,
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'CRC Manager',
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: prussianBlue,
                            fontSize: 30.0,
                          ),
                          speed: const Duration(milliseconds: 150),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            screenFunction: () async {
              _nextScreenToNavigate =
                  await _checkPreferencesAndReturnNextScreen();
              return _nextScreenToNavigate;
            },
            splashIconSize: 400,
            backgroundColor: Colors.white,
            duration: 2000,
          ),
          // IDS Logo at bottom
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ids_logo.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 5),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "Institute",
                      style: TextStyle(fontSize: 12, color: prussianBlue),
                    ),
                    AutoSizeText(
                      "Development",
                      style: TextStyle(fontSize: 12, color: prussianBlue),
                    ),
                    AutoSizeText(
                      "Society",
                      style: TextStyle(fontSize: 12, color: prussianBlue),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> _checkPreferencesAndReturnNextScreen() async {
    Widget nextScreen = const ChooseUserPage();
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool hasValue = prefs.containsKey('isAdmin');
      if (hasValue) {
        nextScreen = const FloorsPage();
      }
      if (hasValue && mounted) {
        final isAdmin = prefs.getBool('isAdmin') ?? false;
        final provider =
            navigatorKey.currentState?.context.read<UserStatusProvider>();

        if (provider != null) {
          provider.updateAdminStatus(isAdmin);
        }
      }
    } catch (e) {
      debugPrint("Error in _checkPreferences function: $e");
    }
    return nextScreen;
  }
}
