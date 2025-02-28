import 'package:auto_size_text/auto_size_text.dart';
import 'package:crc_app/styles/styles.dart';
import 'package:flutter/material.dart';

class NetworkErrorWidget extends StatefulWidget {
  final Function refreshPage;
  const NetworkErrorWidget({super.key, required this.refreshPage});

  @override
  State<NetworkErrorWidget> createState() => _NetworkErrorWidgetState();
}

class _NetworkErrorWidgetState extends State<NetworkErrorWidget> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double boxPadding = deviceWidth * 0.05;
    return Expanded(
      child: SizedBox(
        width: deviceWidth - 2 * boxPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                height: (deviceHeight) * 0.3,
                child: Image.asset("assets/images/internetError.png")),
            Column(
              children: [
                AutoSizeText(
                  "Something went wrong",
                  style: TextStyle(
                      color: prussianBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const AutoSizeText(
                  "Check your connection, then refresh the page.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            OutlinedButton(
                onPressed: () => widget.refreshPage(),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(
                    color: prussianBlue,
                  ),
                ),
                child: AutoSizeText(
                  "Refresh",
                  style: TextStyle(
                      color: prussianBlue, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
