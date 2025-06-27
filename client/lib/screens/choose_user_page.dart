import 'package:auto_size_text/auto_size_text.dart';
import 'package:crc_app/screens/floors_page.dart';
import 'package:crc_app/screens/login_page.dart';
import 'package:crc_app/styles/styles.dart';
import 'package:crc_app/provider/controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseUserPage extends StatefulWidget {
  const ChooseUserPage({super.key});

  @override
  State<ChooseUserPage> createState() => _ChooseUserPageState();
}

class _ChooseUserPageState extends State<ChooseUserPage> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: prussianBlue,
      appBar: AppBar(
        backgroundColor: prussianBlue,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: deviceHeight * 0.3,
                    child: Image.asset("assets/images/VNIT_logo.png")),
                AutoSizeText(
                  "CRC Manager",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: backgroundColor,
                      fontSize: 20),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: deviceWidth,
              padding: EdgeInsets.fromLTRB(deviceWidth * 0.10,
                  deviceHeight * 0.05, deviceWidth * 0.10, deviceHeight * 0.05),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero),
                color: backgroundColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "Login as",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: prussianBlue),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: const ModeButton(
                        buttonIcon: Icons.verified_user, buttonText: "Admin"),
                  ),
                  InkWell(
                      onTap: () async {
                        await setUser(false);
                        if (context.mounted) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FloorsPage()));
                        }
                      },
                      child: const ModeButton(
                          buttonIcon: Icons.group, buttonText: "Guest"))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> setUser(bool isAdmin) async {
    final provider = context.read<UserStatusProvider>();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAdmin', isAdmin);
    provider.updateAdminStatus(isAdmin);
    logDebugMsg("User: ${provider.isAdmin}");
  }
}

class ModeButton extends StatelessWidget {
  final IconData buttonIcon;
  final String buttonText;
  const ModeButton(
      {required this.buttonIcon, required this.buttonText, super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(10.0),
      shadowColor: Colors.grey.withOpacity(1),
      child: Container(
        height: deviceHeight * 0.08,
        width: deviceWidth * 0.80,
        decoration: BoxDecoration(
            color: prussianBlue, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              buttonIcon,
              color: backgroundColor,
            ),
            SizedBox(
              width: deviceWidth * 0.01,
            ),
            AutoSizeText(
              buttonText,
              style: TextStyle(
                  color: backgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}

void logDebugMsg(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
