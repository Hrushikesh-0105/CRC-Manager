import 'package:flutter/material.dart';

Color backgroundColor = const Color(0xfff4f6ff);
Color prussianBlue = const Color(0xff102B3F);
Color moonStone = const Color(0xff53A2BE);
Color violet = const Color(0xff495aff);
Color grey = const Color(0xff222222);
TextStyle heading() {
  return const TextStyle(
      fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white);
}

TextStyle dateStyle(double deviceWidth) {
  return const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff222222));
}

TextStyle eventTextStyle(double deviceWidth) {
  return const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff222222));
}

TextStyle style1() {
  return TextStyle(fontSize: 14, color: grey);
}

TextStyle style2() {
  return TextStyle(fontSize: 14, color: grey);
}

TextStyle style3() {
  return const TextStyle(
      fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold);
}

InputDecoration textfieldstyle1({
  required IconData prefixicon,
  required String hinttext,
  IconButton? suffixIcon,
}) {
  return InputDecoration(
      labelText: hinttext,
      labelStyle: style2(),
      filled: true,
      fillColor: backgroundColor,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xff0e79b2))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: prussianBlue)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xfff0544f))),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xff0e79b2))),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade700)),
      prefixIcon: Icon(prefixicon, size: 20, color: prussianBlue),
      suffixIcon: suffixIcon);
}
