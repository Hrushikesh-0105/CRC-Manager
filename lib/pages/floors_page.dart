// import 'package:crc_app/pages/rooms.dart';
import 'package:crc_app/CustomWidgets/floor_classroom_widget.dart';
import 'package:crc_app/main.dart';
import 'package:crc_app/pages/choose_user_page.dart';
import 'package:crc_app/userStatusProvider/user_and_event_provider.dart';
import 'package:flutter/material.dart';
import 'package:crc_app/styles.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FloorsPage extends StatefulWidget {
  const FloorsPage({
    super.key,
  });

  @override
  State<FloorsPage> createState() => _FloorsPageState();
}

class _FloorsPageState extends State<FloorsPage> {
  bool? isAdmin;

  bool? loadFloors;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFloors = true;
    final provider =
        navigatorKey.currentState!.context.read<UserStatusProvider>();
    isAdmin = provider.isAdmin;
    // getUserType();
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
                margin: const EdgeInsets.only(right: 20),
                child: IconButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('isAdmin');
                      if (mounted && navigatorKey.currentState != null) {
                        final provider = navigatorKey.currentState!.context
                            .read<UserStatusProvider>();
                        provider.updateAdminStatus(false);
                      } // sets _isAdmin to false
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseUserPage()));
                    },
                    icon: const Icon(Icons.logout_outlined,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isAdmin != null
                        ? userWidget(isAdmin!)
                        : const Text("Unable to load"),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    const FloorClassroomWidget(floorNumber: 1),
                    const FloorClassroomWidget(floorNumber: 2),
                    const FloorClassroomWidget(floorNumber: 3),
                    const FloorClassroomWidget(floorNumber: 4),
                    const FloorClassroomWidget(floorNumber: 5),
                    const FloorClassroomWidget(floorNumber: 6),
                  ],
                ),
              )
            : const Text("unable to load"));
  }

  // void getUserType() {
  //   // final prefs = await SharedPreferences.getInstance();
  //   // isAdmin = prefs.getBool('isAdmin');
  //   isAdmin = Provider.of<UserStatusProvider>(context).isAdmin;
  //   // isAdmin = true;
  //   setState(() {
  //     loadFloors = true;
  //   });
  // }
}

Widget userWidget(bool isAdmin) {
  return Row(
    children: [
      Icon(
        isAdmin ? Icons.verified_user : Icons.group,
        color: prussianBlue,
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        isAdmin ? "Admin" : "Guest",
        style: TextStyle(
            color: prussianBlue, fontSize: 16, fontWeight: FontWeight.bold),
      )
    ],
  );
}
