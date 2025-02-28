import 'package:auto_size_text/auto_size_text.dart';
import 'package:crc_app/widgets/floor_classroom_widget.dart';
import 'package:crc_app/screens/about_app_page.dart';
import 'package:crc_app/screens/choose_user_page.dart';
import 'package:crc_app/provider/controller.dart';
import 'package:flutter/material.dart';
import 'package:crc_app/styles/styles.dart';
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
  bool isAdmin = false;
  @override
  void initState() {
    super.initState();
    final provider = context.read<UserStatusProvider>();
    isAdmin = provider.isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double boxPadding = (deviceWidth < 460) ? 16 : 24;
    return Scaffold(
        backgroundColor: prussianBlue,
        appBar: AppBar(
          backgroundColor: prussianBlue,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutAppPage()));
            },
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            iconSize: 20,
          ),
          centerTitle: true,
          title: AutoSizeText(
            "CRC Manager",
            style: heading(),
          ),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 20),
                child: logoutButton(context))
          ],
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              userWidget(isAdmin),
              const FloorClassroomWidget2(floorNumber: 1),
              const FloorClassroomWidget2(floorNumber: 2),
              const FloorClassroomWidget2(floorNumber: 3),
              const FloorClassroomWidget2(floorNumber: 4),
              const FloorClassroomWidget2(floorNumber: 5),
              const FloorClassroomWidget2(floorNumber: 6),
            ],
          ),
        ));
  }

  IconButton logoutButton(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await removeUserStatusFromPrefsAndProvider();
          if (context.mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChooseUserPage()));
          }
        },
        icon: const Icon(Icons.logout_outlined, color: Colors.white, size: 20));
  }

  Future<void> removeUserStatusFromPrefsAndProvider() async {
    final provider = context.read<UserStatusProvider>();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAdmin');
    provider.updateAdminStatus(false);
  }
}

Row userWidget(bool isAdmin) {
  return Row(
    children: [
      Icon(
        isAdmin ? Icons.verified_user : Icons.group,
        color: prussianBlue,
      ),
      const SizedBox(
        width: 5,
      ),
      AutoSizeText(
        isAdmin ? "Admin" : "Guest",
        style: TextStyle(
            color: prussianBlue, fontSize: 16, fontWeight: FontWeight.bold),
      )
    ],
  );
}
