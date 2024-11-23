import 'package:flutter/material.dart';

SnackBar customSnackBar(String message) {
  return SnackBar(
    content: Center(
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          // fontFamily: customfontFamily,
          color: Colors.white,
        ),
      ),
    ),
    duration: const Duration(milliseconds: 500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    backgroundColor: Colors.grey[900],
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(40),
    // width: 20,
  );
}
