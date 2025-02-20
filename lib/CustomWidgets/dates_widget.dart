import 'package:auto_size_text/auto_size_text.dart';
import 'package:crc_app/styles.dart';
import 'package:flutter/material.dart';

Widget dateWidget(int date, String day, Color boxColor, double deviceWidth) {
  // box width:0.84 * deviceWidth / 7;
  Color textColor;
  if (boxColor != backgroundColor) {
    textColor = Colors.white;
  } else {
    textColor = const Color(0xff5e6973);
  }
  return Container(
    //make padding and margin responsive
    margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
    width: 40,
    decoration:
        BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(20)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
          "$date",
          style: dateTextStyle1(deviceWidth, textColor),
        ),
        const SizedBox(
          height: 6,
        ),
        AutoSizeText(day, style: dateTextStyle2(deviceWidth, textColor))
      ],
    ),
  );
}

TextStyle dateTextStyle1(double deviceWidth, Color textColor) {
  return TextStyle(
      // deviceWidth * 0.042
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: textColor);
}

TextStyle dateTextStyle2(double deviceWidth, Color textColor) {
  return TextStyle(
      // deviceWidth * 0.042
      fontSize: 10,
      color: textColor);
}

// Color backgroundColor = const Color(0xfff4f6ff);
