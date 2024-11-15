// import 'package:crc_app/pages/rooms.dart';
import 'package:crc_app/CustomWidgets/floor_classroom_widget.dart';
import 'package:crc_app/pages/choose_user_page.dart';
import 'package:flutter/material.dart';
import 'package:crc_app/styles.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FloorsPage extends StatefulWidget {
  const FloorsPage({
    super.key,
  });

  @override
  State<FloorsPage> createState() => _FloorsPageState();
}

class _FloorsPageState extends State<FloorsPage> {
  String? user;
  bool? loadFloors;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFloors = false;
    getUserType();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double boxPadding = deviceWidth * 0.05;
    return Scaffold(
        backgroundColor: prussianBlue,
        appBar: AppBar(
          backgroundColor: prussianBlue,
          leading: IconButton(
            onPressed: () {
              SystemNavigator.pop(); //for exiting the app
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
            // iconSize: deviceWidth * 0.08,
            iconSize: 20,
          ),
          centerTitle: true,
          title: Text(
            "CRC Manager",
            style: heading(),
          ),
          actions: [
            Container(
                margin: EdgeInsets.only(right: 20),
                child: IconButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs
                          .remove('User'); // Removes the stored 'username'
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseUserPage()));
                    },
                    icon: Icon(Icons.logout_outlined,
                        color: Colors.white, size: 20)))
          ],
        ),
        body: loadFloors!
            ? Container(
                width: deviceWidth,
                height: deviceHeight - appBarHeight,
                padding: EdgeInsets.all(boxPadding),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    user != null ? userWidget(user!) : Text("Unable to load"),
                    FloorClassroomWidget(floorNumber: 1),
                    FloorClassroomWidget(floorNumber: 2),
                    FloorClassroomWidget(floorNumber: 3),
                    FloorClassroomWidget(floorNumber: 4),
                    FloorClassroomWidget(floorNumber: 5),
                    FloorClassroomWidget(floorNumber: 6),
                  ],
                ),
              )
            : Text("unable to load"));
  }

  Future<void> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    user = prefs.getString('User');
    setState(() {
      loadFloors = true;
    });
  }
}

Widget userWidget(String user) {
  return Row(
    children: [
      Icon(
        user == "Admin" ? Icons.verified_user : Icons.group,
        color: prussianBlue,
      ),
      SizedBox(
        width: 5,
      ),
      Text(
        user,
        style: TextStyle(
            color: prussianBlue, fontSize: 16, fontWeight: FontWeight.bold),
      )
    ],
  );
}
