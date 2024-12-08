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
    padding: const EdgeInsets.all(5),
    margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
    // width: deviceWidth * 0.13,
    width: 40,
    decoration:
        BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(50)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$date",
          style: dateTextStyle(deviceWidth, textColor),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(day,
            style: dateTextStyle(deviceWidth, textColor)
                .copyWith(fontWeight: FontWeight.normal))
      ],
    ),
  );
}

TextStyle dateTextStyle(double deviceWidth, Color textColor) {
  return TextStyle(
      // deviceWidth * 0.042
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: textColor);
}

// Color backgroundColor = const Color(0xfff4f6ff);
