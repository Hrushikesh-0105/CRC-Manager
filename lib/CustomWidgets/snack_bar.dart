import 'package:flutter/material.dart';

SnackBar customSnackBar(String message) {
  return SnackBar(
    content: Center(
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          // fontFamily: customfontFamily,
          color: Color(0xffF8F8F8),
        ),
      ),
    ),
    duration: const Duration(milliseconds: 1000),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    backgroundColor: Color(0xff333333),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(40),
    // width: 20,
  );
}
