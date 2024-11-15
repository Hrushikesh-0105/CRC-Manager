import 'package:crc_app/CustomWidgets/calandar_widget.dart';
import 'package:crc_app/CustomWidgets/datesWidget.dart';
import 'package:crc_app/pages/add_event_page.dart';
import 'package:crc_app/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventsPage extends StatefulWidget {
  final floorNumber;
  final roomNumber;
  const EventsPage(
      {required this.floorNumber, required this.roomNumber, super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  //database related
  List<Map<String, dynamic>> eventDataList = [
    {
      "eventName": "Aarohi",
      "organiserName": "Hrushikesh",
      "mobileNumber": "9347808844",
      "eventDate": ""
    }
  ];
  bool isLoading = false;

  //database related

  // test data
  List<Event> testDisplayEvents = [
    Event(
        title: "Ids",
        startTime: DateTime(2024, 11, 15, 14),
        endTime: DateTime(2024, 11, 15, 15),
        color: Colors.redAccent),
    Event(
        title: "Axis",
        startTime: DateTime(2024, 11, 15, 10),
        endTime: DateTime(2024, 11, 15, 12),
        color: Colors.orangeAccent)
  ];
  //test data

  DateTime currentDate = DateTime.now();
  // DateTime? startOfMonth;
  // DateTime? endOfMonth;
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
    // loadData();
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
            if (!isLoading)
              Expanded(
                child: CalandarWidget(
                  currentDate: currentDate,
                  events: testDisplayEvents,
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return AddEventPage(
                    eventDate: currentDate,
                    floorNumber: widget.floorNumber,
                    roomNumber: widget.roomNumber);
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
    // get the data here then setstate
    setState(() {
      if (kDebugMode) {
        print("loading data");
      }
      isLoading = false;
    });
  }
}

class Event {
  //test
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  Event(
      {required this.title,
      required this.startTime,
      required this.endTime,
      required this.color});
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> events) {
    appointments = events.map((event) {
      return Appointment(
        startTime: event.startTime,
        endTime: event.endTime,
        subject: event.title,
        color: event.color, // Customize color as needed
      );
    }).toList();
  }
}
