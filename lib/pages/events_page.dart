import 'dart:async';
import 'package:crc_app/Api/api.dart';
import 'package:crc_app/CustomWidgets/calandar_widget.dart';
import 'package:crc_app/CustomWidgets/dates_widget.dart';
import 'package:crc_app/CustomWidgets/legend.dart';
import 'package:crc_app/CustomWidgets/network_error_widget.dart';
import 'package:crc_app/CustomWidgets/no_events_widget.dart';
import 'package:crc_app/CustomWidgets/snack_bar.dart';
import 'package:crc_app/main.dart';
import 'package:crc_app/pages/add_event_page.dart';
import 'package:crc_app/styles.dart';
import 'package:crc_app/userStatusProvider/user_and_event_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  final int floorNumber;
  final int roomNumber;
  const EventsPage(
      {required this.floorNumber, required this.roomNumber, super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool? isAdmin;
  bool isLoading = false;
  bool networkError = false;
  DateTime currentDate = DateTime.now();
  Map<int, String> currentMonthDatesMap = {};
  List<Map<String, DateTime>> currentEventTimes = [];
  ScrollController dateScrollController =
      ScrollController(initialScrollOffset: (DateTime.now().day - 1) * 40);

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
    loadData(context);
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
    //!Test
    // final provider =
    //     navigatorKey.currentState!.context.read<UserStatusProvider>();
    // provider.clearEvents();
    // DateTime testDate = DateTime(2024, 12, 13);
    // String eventDateString = DateFormat('yyyy-MM-dd').format(testDate);
    // DateTime startDate = DateTime(
    //   testDate.year,
    //   testDate.month,
    //   testDate.day,
    //   15, // Hours (e.g., 3 PM)
    //   0, // Minutes
    //   0, // Seconds
    // );
    // DateTime endDate = DateTime(
    //   testDate.year,
    //   testDate.month,
    //   testDate.day,
    //   17, // Hours (e.g., 3 PM)
    //   0, // Minutes
    //   0, // Seconds
    // );
    // Map<String, dynamic> eventMap = {
    //   "_id": "1234",
    //   "EventName": "Axis",
    //   "OrganiserName": "Hrushikesh",
    //   // "MobileNumber": mobileNumberTextField.text.trim(),
    //   "Date": eventDateString,
    //   "BookedFrom": startDate.toString(),
    //   "BookedTill": endDate.toString(),
    //   "RoomName": "${widget.floorNumber}-${widget.roomNumber}",
    //   "Status": "inUse",
    // };
    // provider.addEventData(eventMap);
    //!Test
    //! DATA related
    currentEventTimes.clear();
    //widget rebuilds if event data is changed
    final eventData = context.watch<UserStatusProvider>().userEventData;
    createCurrentEventTimesList(eventData);
    logDebugMsg("Current Event Data:$eventData");
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
          actions: [refreshIcon()]),
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
                      await pickDate(context);
                      setState(() {
                        isLoading = true;
                      });
                      await loadData(context);
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
              height: 56,
              child: SizedBox(
                width: deviceWidth - 2 * boxPadding,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
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
                        await loadData(context);
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
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Events",
                  style: dateStyle(deviceWidth),
                ),
                const ColorCodedLegend()
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (isLoading)
              loadingIndicatorWidget()
            else if (networkError)
              NetworkErrorWidget(refreshPage: refreshPage)
            else if (eventData.isEmpty)
              const NoEventsWidget()
            else
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

  Future<void> loadData(BuildContext context) async {
    SnackbarType snackbartextType = SnackbarType.error;
    networkError = true;
    logDebugMsg("Loading data");
    String snackbarText = "Network Error";
    //!Data related
    final provider =
        navigatorKey.currentState!.context.read<UserStatusProvider>();
    provider.clearEvents();
    currentEventTimes.clear();
    String eventDateString = DateFormat('yyyy-MM-dd').format(currentDate);
    String roomName = "${widget.floorNumber}-${widget.roomNumber}";
    try {
      const timeoutDuration = Duration(seconds: 10);
      List<Map<String, dynamic>>? fetchedData = await ApiService()
          .getData(roomName, eventDateString)
          .timeout(timeoutDuration, onTimeout: () {
        // This function is called if the operation takes too long
        snackbarText = "Connection Timed out";
        throw TimeoutException("Connection timed out");
      });

      logDebugMsg("fetched data: $fetchedData");

      if (fetchedData != null) {
        provider.setEventDataList(fetchedData);
        networkError = false;
      } else {
        logDebugMsg("show snakbar");
        showSnackBar(context, snackbarText, snackbartextType);
      }
    } catch (e) {
      logDebugMsg("Error in fetching data: $e");
      showSnackBar(context, snackbarText, snackbartextType);
    }
    //!Data related
    setState(() {
      isLoading = false;
    });
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
    DateTime startOfMonth;
    DateTime endOfMonth;
    startOfMonth = DateTime(currentDate.year, currentDate.month, 1);
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

  void createCurrentEventTimesList(
      List<Map<String, dynamic>> currentEventsList) {
    for (var event in currentEventsList) {
      DateTime bookedFrom = DateTime.parse(event["BookedFrom"]);
      DateTime bookedTill = DateTime.parse(event["BookedTill"]);
      currentEventTimes
          .add({'BookedFrom': bookedFrom, 'BookedTill': bookedTill});
    }
    if (kDebugMode) {
      print(currentEventTimes);
    }
  }

  void refreshPage() async {
    setState(() {
      isLoading = true;
    });
    await loadData(context);
  }

  Container refreshIcon() {
    return Container(
        margin: const EdgeInsets.only(right: 20),
        child: IconButton(
            onPressed: () => refreshPage(),
            icon: Icon(
              Icons.refresh_outlined,
              color: Colors.white,
              size: 24,
            )));
  }

  Expanded loadingIndicatorWidget() {
    return Expanded(
      child: Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            color: prussianBlue,
          ),
        ),
      ),
    );
  }
}

void logDebugMsg(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

void showSnackBar(
    BuildContext context, String snackbarText, SnackbarType typeOfMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackbar(message: snackbarText, type: typeOfMessage)
          .build(context));
}
