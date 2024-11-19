import 'package:crc_app/CustomWidgets/calandar_widget.dart';
import 'package:crc_app/CustomWidgets/datesWidget.dart';
import 'package:crc_app/main.dart';
import 'package:crc_app/pages/add_event_page.dart';
import 'package:crc_app/styles.dart';
import 'package:crc_app/userStatusProvider/user_status_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart';
import 'package:crc_app/Api/api.dart';

//if u cange the start time and end time of the day, change it in slandar and in the generate start times function too
// void main() {
//   runApp(MaterialApp(
//     theme: ThemeData(
//       fontFamily: 'OpenSans',
//     ),
//     debugShowCheckedModeBanner: false,
//     home: EventsPage(
//       floorNumber: 1,
//       roomNumber: 2,
//     ),
//   ));
// }

class EventsPage extends StatefulWidget {
  final floorNumber;
  final roomNumber;
  const EventsPage(
      {required this.floorNumber, required this.roomNumber, super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool? isAdmin;
  //database related
  List<Map<String, dynamic>> eventDataList = [
    {
      "id": "1234",
      "eventName": "Axis",
      "organiserName": "Tarun",
      "mobileNumber": "8074465290",
      "eventDate": "2024-11-19",
      "startTime": "8",
      "endTime": "11",
      "status": "free" //3 types booked, inUse,free
    },
    {
      "id": "5678",
      "eventName": "Aarohi",
      "organiserName": "vaibhav",
      "mobileNumber": "9854783912",
      "eventDate": "2024-11-19",
      "startTime": "12",
      "endTime": "14",
      "status": "inUse" //3 types booked, inUse,free
    },
    {
      "id": "9112",
      "eventName": "IDS",
      "organiserName": "Hrushikesh",
      "mobileNumber": "9347808844",
      "eventDate": "2024-11-19",
      "startTime": "16",
      "endTime": "18",
      "status": "booked" //3 types booked, inUse,free
    }
  ];
  bool isLoading = false;

  //database related

  DateTime currentDate = DateTime.now();
  //have declared this variables in updatemap function
  Map<int, String> currentMonthDatesMap = {};
  //scroll controller for dates
  ScrollController dateScrollController =
      ScrollController(initialScrollOffset: (DateTime.now().day - 1) * 40);
  //setting initial position of the date scrolling

  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final List<String> dayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  void initState() {
    super.initState();
    updateDateMap();
    // animateScroller();
    final provider =
        navigatorKey.currentState!.context.read<UserStatusProvider>();
    isAdmin = provider.isAdmin;
    isLoading = true;
    loadData();
  }

  @override
  void dispose() {
    dateScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double boxPadding = deviceWidth * 0.05;

    List<Map<String, DateTime>> currentEventTimes = [];

    for (var event in eventDataList) {
      DateTime eventDate = DateTime.parse(event["eventDate"]);
      int startTime = int.parse(event["startTime"]);
      int endTime = int.parse(event["endTime"]);
      currentEventTimes.add({
        'startTime':
            DateTime(eventDate.year, eventDate.month, eventDate.day, startTime),
        'endTime':
            DateTime(eventDate.year, eventDate.month, eventDate.day, endTime),
      });
    }

    return Scaffold(
      backgroundColor: prussianBlue,
      appBar: AppBar(
        backgroundColor: prussianBlue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
          "CRC ${widget.floorNumber}-${widget.roomNumber}",
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
            //first row for month, year and choosing date button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${monthNames[currentDate.month - 1]} ${currentDate.year}",
                  style: dateStyle(deviceWidth),
                ),
                IconButton(
                    onPressed: () {
                      pickDate(context);
                    },
                    icon: Icon(
                      Icons.calendar_month_outlined,
                      color: grey,
                      size: 28,
                    ))
              ],
            ),
            //selecting dates scroll view
            SizedBox(
              //sized box is needed to limit the height of the dateWidget
              //height:deviceHeight*0.11
              height: 56,
              child: SizedBox(
                width: deviceWidth - 2 * boxPadding,
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal, // Make the ListView horizontal
                  controller: dateScrollController,
                  itemCount: currentMonthDatesMap.length,
                  itemBuilder: (context, index) {
                    Color currentColor;
                    if (currentDate.day == (index + 1)) {
                      currentColor = prussianBlue;
                    } else {
                      currentColor = backgroundColor;
                    }
                    return InkWell(
                      onTap: () {
                        currentDate = DateTime(
                          currentDate.year,
                          currentDate.month,
                          index + 1,
                        );
                        setState(() {});
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: dateWidget(
                          index + 1,
                          "${currentMonthDatesMap[index + 1]}",
                          currentColor,
                          deviceWidth),
                    );
                  },
                ),
              ),
            ),
            //
            // const Divider(),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Events",
              style: dateStyle(deviceWidth),
            ),
            const SizedBox(
              height: 10,
            ),

            const SizedBox(
              height: 10,
            ),
            if (!isLoading)
              Expanded(
                child: CalandarWidget(
                  currentDate: currentDate,
                  eventsMap: eventDataList,
                ),
              )
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: isAdmin!,
        child: FloatingActionButton(
          onPressed: () async {
            await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return AddEventPage(
                    eventDate: currentDate,
                    floorNumber: widget.floorNumber,
                    roomNumber: widget.roomNumber,
                    currentEventTimes: currentEventTimes,
                  );
                });
            loadData();
          },
          backgroundColor: prussianBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Set the corner radius
          ),
          child: Icon(
            Icons.add,
            color: backgroundColor,
          ),
        ),
      ),
    );
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(DateTime.now().year + 50));
    if (pickedDate != null) {
      currentDate = pickedDate;
      updateDateMap();
    }
  }

  void updateDateMap() {
    // to get device width for scroll controller
    //double deviceWidth = MediaQuery.of(context).size.width;
    // Get the first day of the current month
    DateTime startOfMonth;
    DateTime endOfMonth;
    startOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    // Get the last day of the current month
    endOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
    currentMonthDatesMap.clear();
    int weekIndex = startOfMonth.weekday - 1;
    for (int date = startOfMonth.day; date <= endOfMonth.day; date++) {
      if (weekIndex > 6) {
        weekIndex = 0;
      }
      currentMonthDatesMap[date] = dayNames[weekIndex];
      weekIndex++;
    }
    animateScroller();
    // print(currentMonthDatesMap);
    setState(() {});
  }

  void animateScroller() {
    dateScrollController.animateTo(
      (currentDate.day - 1) *
          (40), // Assuming each date takes 1/7th of the device width
      //0.84*348/7
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void loadData() async {
    if (kDebugMode) {
      print("loading data");
    }
    // get the data here then setstate
    try {
      if (kDebugMode) {
        List<dynamic>? data = await ApiService().getData(
            "${widget.floorNumber}-${widget.roomNumber}", "2024-11-01");
        if (data != null) {
          print(data);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
