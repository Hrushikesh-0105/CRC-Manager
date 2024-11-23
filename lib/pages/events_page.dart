import 'package:crc_app/CustomWidgets/calandar_widget.dart';
import 'package:crc_app/CustomWidgets/datesWidget.dart';
import 'package:crc_app/main.dart';
import 'package:crc_app/pages/add_event_page.dart';
import 'package:crc_app/styles.dart';
import 'package:crc_app/userStatusProvider/user_and_event_provider.dart';
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
  // List<Map<String, dynamic>> eventDataList = [
  // {
  //   "id": "1234",
  //   "eventName": "Axis",
  //   "organiserName": "Tarun",
  //   "mobileNumber": "8074465290",
  //   "eventDate": "2024-11-24 00:00:00.000",
  //   "startTime": "2024-11-24 12:00:00.000",
  //   "endTime": "2024-11-24 17:00:00.000",
  //   "RoomName": "1-2",
  //   "status": "free" //3 types booked, inUse,free
  // },
  // ];
  // List<Map<String, dynamic>> eventDataList = [];
  bool isLoading = false;

  //database related

  DateTime currentDate = DateTime.now();
  //have declared this variables in updatemap function
  Map<int, String> currentMonthDatesMap = {};
  List<Map<String, DateTime>> currentEventTimes = [];
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
    // final events = context.watch<UserStatusProvider>().userEventData;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double boxPadding = deviceWidth * 0.05;

    //! DATA related
    currentEventTimes.clear();
    final eventData = context.watch<UserStatusProvider>().userEventData;
    createCurrentEventTimesList(eventData);
    debugPrint("test:$eventData");
    //! Data related

    return Scaffold(
      backgroundColor: prussianBlue,
      appBar: AppBar(
        backgroundColor: prussianBlue,
        leading: IconButton(
          onPressed: () {
            //clearing the events
            context.read<UserStatusProvider>().clearEvents();
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
                    onPressed: () async {
                      pickDate(context);
                      await loadData();
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
                      onTap: () async {
                        currentDate = DateTime(
                          currentDate.year,
                          currentDate.month,
                          index + 1,
                        );
                        setState(() {
                          isLoading = true;
                        });
                        await loadData();
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

            // if (!isLoading)
            Expanded(
                child: CalandarWidget(
              currentDate: currentDate,
              eventsMap: eventData,
            ))
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: isAdmin!,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
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
            // loadData();
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

  Future<void> loadData() async {
    if (kDebugMode) {
      print("loading data");
    }
    final provider =
        navigatorKey.currentState!.context.read<UserStatusProvider>();
    provider.clearEvents();
    currentEventTimes.clear();
    //TODO receive data here
    setState(() {
      isLoading = false;
    });
  }

  void createCurrentEventTimesList(
      List<Map<String, dynamic>> currentEventsList) {
    for (var event in currentEventsList) {
      // DateTime eventDate = DateTime.parse(event["eventDate"]);
      // int startTime = int.parse(event["startTime"]);
      // int endTime = int.parse(event["endTime"]);
      DateTime startTime = DateTime.parse(event["startTime"]);
      DateTime endTime = DateTime.parse(event["endTime"]);
      currentEventTimes.add({
        'startTime':
            // DateTime(eventDate.year, eventDate.month, eventDate.day, startTime),
            startTime,
        'endTime':
            // DateTime(eventDate.year, eventDate.month, eventDate.day, endTime),
            endTime
      });
    }
    print(currentEventTimes);
  }
}
