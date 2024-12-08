import 'package:crc_app/Api/api.dart';
import 'package:crc_app/CustomWidgets/snack_bar.dart';
import 'package:crc_app/main.dart';
import 'package:crc_app/pages/choose_user_page.dart';
import 'package:crc_app/pages/floors_page.dart';
import 'package:crc_app/styles.dart';
import 'package:crc_app/userStatusProvider/user_and_event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: prussianBlue,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ChooseUserPage()));
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          iconSize: 20,
        ),
      ),
      backgroundColor: prussianBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: (deviceHeight - appBarHeight) * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: (deviceHeight) * 0.3,
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
            SizedBox(
              height: (deviceHeight - appBarHeight) * 0.5,
              // flex: 7,
              child: Container(
                width: deviceWidth,
                padding: EdgeInsets.fromLTRB(
                    deviceWidth * 0.10,
                    deviceHeight * 0.05,
                    deviceWidth * 0.10,
                    deviceHeight * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: backgroundColor,
                ),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: prussianBlue),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: _mobileNumberController,
                          keyboardType:
                              TextInputType.phone, // Show numeric keypad
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly
                          ],

                          decoration:
                              textfieldstyle1(Icons.phone, "Mobile Number"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            } else if (value.length != 10) {
                              return "Enter 10 digit mobile number";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: textfieldstyle1(Icons.lock, "Password"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            bool isUserLoggedIn = await _login();
                            if (isUserLoggedIn) {
                              //updating provide
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FloorsPage()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize:
                                Size(deviceWidth * 0.80, deviceHeight * 0.06),
                            backgroundColor: prussianBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              // Rounded corners
                            ),
                            elevation: 5, // Elevation (shadow)
                          ),
                          child: Text(
                            'Login',
                            style:
                                TextStyle(fontSize: 18, color: backgroundColor),
                          ),
                        ),
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> setUser(bool isAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAdmin', isAdmin);
    if (mounted && navigatorKey.currentState != null) {
      final provider =
          navigatorKey.currentState!.context.read<UserStatusProvider>();
      provider.updateAdminStatus(true);
    }
  }

  Future<bool> _login() async {
    bool loggedIn = false;
    String snakbarText = "";
    String typedMobileNo = _mobileNumberController.text.trim();
    String typedPass = _passwordController.text.trim();
    if (_formKey.currentState!.validate()) {
      //get the login credentials here and check
      //TODO get the phone number and password here
      int statusCode = 0;
      try {
        statusCode =
            await ApiService().authenticateLogin(typedMobileNo, typedPass);
      } catch (e) {
        debugPrint("Error:$e");
        snakbarText = "Connection Failed";
      }
      if (statusCode == 200) {
        await setUser(true); //setting user in shared preferences
        loggedIn = true; //setting the user as admin
        snakbarText = "Logged in";
      } else if (statusCode == 404) {
        snakbarText = "User dosen't exist";
      } else if (statusCode == 401) {
        snakbarText = "Incorrect password";
      } else if (statusCode == 500) {
        snakbarText = "Server Error";
      } else {
        snakbarText = "Connection Failed";
        print("Error here");
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(snakbarText),
        );
      }
    }
    return loggedIn;
  }
}
