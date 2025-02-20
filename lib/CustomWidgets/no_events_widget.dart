import 'package:auto_size_text/auto_size_text.dart';
import 'package:crc_app/styles.dart';
import 'package:flutter/material.dart';

class NoEventsWidget extends StatefulWidget {
  const NoEventsWidget({super.key});

  @override
  State<NoEventsWidget> createState() => _NoEventsWidgetState();
}

class _NoEventsWidgetState extends State<NoEventsWidget> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double boxPadding = deviceWidth * 0.05;
    return Expanded(
      child: SizedBox(
        width: deviceWidth - 2 * boxPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: (deviceHeight) * 0.2,
                child: Image.asset("assets/images/noEventsToday.png")),
            const SizedBox(
              height: 20,
            ),
            AutoSizeText(
              "No events on this day",
              style: TextStyle(
                  color: prussianBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
