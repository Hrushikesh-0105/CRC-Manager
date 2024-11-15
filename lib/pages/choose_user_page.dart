import 'package:crc_app/pages/floors_page.dart';
import 'package:crc_app/pages/login_page.dart';
import 'package:crc_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(CRCManagerApp());
}

class CRCManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChooseUserPage(),
    );
  }
}

class ChooseUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // double appBarHeight = AppBar().preferredSize.height;
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
                Text(
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
                borderRadius: BorderRadius.circular(20),
                color: backgroundColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login as",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: prussianBlue),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: const ModeButton(
                        buttonIcon: Icons.verified_user, buttonText: "Admin"),
                  ),
                  InkWell(
                      onTap: () async {
                        await setUser("Guest");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FloorsPage()));
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

  Future<void> setUser(String selectedUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('User', selectedUser);
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
      elevation: 4.0, // Adjust elevation here
      borderRadius:
          BorderRadius.circular(10.0), // Optional: adds rounded corners
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
            Text(
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
