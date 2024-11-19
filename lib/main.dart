// import 'package:crc_app/pages/mode.dart';
// import 'package:crc_app/pages/mode.dart';
// import 'package:crc_app/pages/choose_user_page.dart';
import 'package:crc_app/pages/splash_screen.dart';
import 'package:crc_app/userStatusProvider/user_status_provider.dart';
// import 'package:crc_app/pages/thirdPage.dart';
// import 'package:crc_app/pages/thirdPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserStatusProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        fontFamily: 'OpenSans',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
