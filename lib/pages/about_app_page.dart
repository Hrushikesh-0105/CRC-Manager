import 'package:auto_size_text/auto_size_text.dart';
import 'package:crc_app/CustomWidgets/profile_card.dart';
import 'package:crc_app/styles.dart';
import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double boxPadding = (deviceWidth < 460) ? 16 : 24;
    final List<Map<String, String>> developers = [
      {
        'name': 'Hrushikesh Musaloj',
        'rollNumber': 'BT23CSE024',
        'imagePath': 'assets/images/Hrushikesh.jpg',
        'position': 'Junior Developer'
      },
      {
        'name': 'Shivam Raj',
        'rollNumber': 'BT23MME070',
        'imagePath': 'assets/images/shivam_raj.jpeg',
        'position': 'Junior Developer'
      },
      {
        'name': 'Luv Neekhra',
        'rollNumber': 'BT23CIV089',
        'imagePath': 'assets/images/Luv.jpg',
        'position': 'Junior Developer'
      },
      {
        'name': 'Aritra Sarkar',
        'rollNumber': 'BT23CME092',
        'imagePath': 'assets/images/Aritra.jpg',
        'position': 'Junior Developer'
      },
    ];
    return Scaffold(
        backgroundColor: prussianBlue,
        appBar: AppBar(
          backgroundColor: prussianBlue,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            iconSize: 20,
          ),
          centerTitle: true,
          title: AutoSizeText(
            "About App",
            style: heading(),
          ),
        ),
        body: Container(
          width: deviceWidth,
          height: deviceHeight - appBarHeight,
          padding: EdgeInsets.all(boxPadding),
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingWidget("Developers"),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: developers.length,
                    itemBuilder: (context, index) {
                      return ProfileCard(info: developers[index]);
                    }),
              ),
            ],
          ),
        ));
  }
}

Widget headingWidget(String text) {
  return AutoSizeText(
    "Developers",
    style: TextStyle(
      color: prussianBlue,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );
}
