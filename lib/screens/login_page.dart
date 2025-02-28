import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crc_app/Api/api.dart';
import 'package:crc_app/widgets/snack_bar.dart';
import 'package:crc_app/screens/choose_user_page.dart';
import 'package:crc_app/screens/floors_page.dart';
import 'package:crc_app/styles/styles.dart';
import 'package:crc_app/provider/controller.dart';
import 'package:flutter/foundation.dart';
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
  bool _isLoading = false;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChooseUserPage()));
                },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          iconSize: 20,
        ),
      ),
      backgroundColor: prussianBlue,
      body: SafeArea(
        child: SingleChildScrollView(
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
              SizedBox(
                height: (deviceHeight - appBarHeight) * 0.5,
                child: Container(
                  width: deviceWidth,
                  padding: EdgeInsets.fromLTRB(
                      deviceWidth * 0.10,
                      deviceHeight * 0.05,
                      deviceWidth * 0.10,
                      deviceHeight * 0.05),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero),
                    color: backgroundColor,
                  ),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AutoSizeText(
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
                            enabled: !_isLoading,
                            controller: _mobileNumberController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            cursorColor: prussianBlue,
                            decoration: textfieldstyle1(
                                prefixicon: Icons.phone,
                                hinttext: "Mobile Number"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter mobile number";
                              } else if (value.length != 10) {
                                return "Enter 10 digit mobile number";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: !_isLoading,
                            controller: _passwordController,
                            obscureText: _obscureText,
                            cursorColor: prussianBlue,
                            decoration: textfieldstyle1(
                                prefixicon: Icons.lock,
                                hinttext: "Password",
                                suffixIcon: IconButton(
                                  onPressed: () => toggleObscureText(),
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.grey[700],
                                  ),
                                )),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter password";
                              }
                              return null;
                            },
                          ),
                          _isLoading
                              ? loadingIndicatorWidget()
                              : ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    bool isUserLoggedIn = await _login();
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (isUserLoggedIn && context.mounted) {
                                      //updating provide
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const FloorsPage()));
                                    }
                                  },
                                  style: loginButtonStyle(
                                      deviceWidth, deviceHeight),
                                  child: AutoSizeText(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 18, color: backgroundColor),
                                  ),
                                ),
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  ButtonStyle loginButtonStyle(double deviceWidth, double deviceHeight) {
    return ElevatedButton.styleFrom(
      fixedSize: Size(deviceWidth * 0.80, deviceHeight * 0.06),
      backgroundColor: prussianBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // Rounded corners
      ),
      elevation: 5, // Elevation (shadow)
    );
  }

  Future<void> setUser(bool isAdmin) async {
    final provider = context.read<UserStatusProvider>();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAdmin', isAdmin);
    provider.updateAdminStatus(true);
  }

  Future<bool> _login() async {
    bool loggedIn = false;
    String snakbarText = "";
    SnackbarType snakbarTextType = SnackbarType.error;
    String typedMobileNo = _mobileNumberController.text.trim();
    String typedPassword = _passwordController.text.trim();
    if (_formKey.currentState!.validate()) {
      int statusCode = 0;
      try {
        const timeoutDuration = Duration(seconds: 10);
        statusCode =
            await ApiService.authenticateLogin(typedMobileNo, typedPassword)
                .timeout(timeoutDuration, onTimeout: () {
          // This function is called if the operation takes too long
          snakbarText = "Connection timed out";
          throw TimeoutException("Connection timed out");
        });
      } catch (e) {
        logDebugMsg("Error:$e");
        snakbarText = "Network Error";
      }
      if (statusCode == 200) {
        await setUser(true); //setting user as admin in shared preferences
        loggedIn = true;
        snakbarText = "Logged in";
      } else if (statusCode == 404) {
        snakbarText = "User dosen't exist";
      } else if (statusCode == 401) {
        snakbarText = "Incorrect password";
      } else if (statusCode == 500) {
        snakbarText = "Server Error";
      } else {
        snakbarText = "Connection Failed";
        logDebugMsg("Error here");
      }
      if (loggedIn) snakbarTextType = SnackbarType.success;
      CustomSnackbar.show(message: snakbarText, type: snakbarTextType);
    }
    return loggedIn;
  }

  Widget loadingIndicatorWidget() {
    return Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(
          color: prussianBlue,
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
