import 'package:animated_splash_screen/animated_splash_screen.dart';
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
  // Default screen to navigate
  Widget _nextScreenToNavigate = ChooseUserPage();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return AnimatedSplashScreen.withScreenFunction(
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
        _nextScreenToNavigate = await _checkPreferencesAndReturnNextScreen();
        return _nextScreenToNavigate;
      },
      splashIconSize: 400,
      backgroundColor: Colors.white,
      duration: 2000,
    );
  }

  Future<Widget> _checkPreferencesAndReturnNextScreen() async {
    Widget nextScreen = ChooseUserPage();
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

        // Update admin status
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
