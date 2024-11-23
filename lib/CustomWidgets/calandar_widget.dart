// import 'package:crc_app/Api/api.dart';
import 'package:crc_app/CustomWidgets/snack_bar.dart';
import 'package:crc_app/main.dart';
import 'package:crc_app/styles.dart';
import 'package:crc_app/userStatusProvider/user_and_event_provider.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:crc_app/pages/events_page.dart';

class CalandarWidget extends StatefulWidget {
  final DateTime currentDate;
  final List<Map<String, dynamic>> eventsMap;
  const CalandarWidget(
      {required this.currentDate, required this.eventsMap, super.key});

  @override
  State<CalandarWidget> createState() => _CalandarWidgetState();
}

class _CalandarWidgetState extends State<CalandarWidget> {
  bool? isAdmin;
  List<Map<String, dynamic>> diaplayEventsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider =
        navigatorKey.currentState!.context.read<UserStatusProvider>();
    isAdmin = provider.isAdmin;
    // print("Events map:  ${widget.eventsMap}");
    createDisplayEventsMap();
  }

  @override
  void didUpdateWidget(CalandarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    //! Rebuilds when data changes
    diaplayEventsList.clear(); // Clear the old list
    createDisplayEventsMap();
    // print(widget.eventsMap); // Create new display events
    setState(() {});
    // if (widget.eventsMap != oldWidget.eventsMap) {
    //  // Trigger rebuild
    // }
  }

  //test
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      headerHeight: 0,
      viewHeaderHeight: 0,

      backgroundColor: backgroundColor,
      minDate: DateTime(widget.currentDate.year, widget.currentDate.month,
          widget.currentDate.day, 8),
      maxDate: DateTime(widget.currentDate.year, widget.currentDate.month,
          widget.currentDate.day, 20),
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 7.0, // Start displaying from 8 a.m.
        endHour: 21.0, // End displaying at 8 p.m.
        timeIntervalHeight: 60,
        timeInterval: Duration(hours: 1),
      ),
      selectionDecoration: BoxDecoration(
        border: Border.all(
          color: prussianBlue, // Customize selected border color
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4), // Optional: rounding the border
      ),
      todayHighlightColor: prussianBlue,
      onTap: (CalendarTapDetails details) {
        //TODO show dialogue box of event info here
        String currentId = details.appointments![0].id;
        Map<String, dynamic> currentEvent = findCurrentEvent(currentId);
        // print(currentEvent);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return EventDialogBox(
                  currentEventMap: currentEvent, isAdmin: isAdmin!);
            });
      },
      // cellBorderColor: prussianBlue,
      //data
      dataSource: EventDataSource(diaplayEventsList),
      appointmentTextStyle: const TextStyle(
        fontSize: 14, // Custom font size
        fontWeight: FontWeight.bold, // Custom font weight
        color: Colors.white, // Text color
      ),
    );
  }

  void createDisplayEventsMap() {
    debugPrint("entered displayevents function"); //TODO remove this
    for (Map<String, dynamic> event in widget.eventsMap) {
      Map<String, dynamic> displayEvent = {};
      // DateTime eventDate = DateTime.parse(event["eventDate"]);
      // int startTime = int.parse(event["startTime"]);
      // int endTime = int.parse(event["endTime"]);
      displayEvent["id"] = event["id"];
      displayEvent["title"] = event["eventName"];
      // displayEvent["startTime"] =
      //     DateTime(eventDate.year, eventDate.month, eventDate.day, startTime);
      // displayEvent["endTime"] =
      //     DateTime(eventDate.year, eventDate.month, eventDate.day, endTime);
      //TODO added below two lines
      displayEvent["startTime"] = DateTime.parse(event["startTime"]);
      displayEvent["endTime"] = DateTime.parse(event["endTime"]);
      if (event["status"] == "Booked") {
        displayEvent["color"] = Colors.orangeAccent;
      } else if (event["status"] == "inUse") {
        displayEvent["color"] = Colors.redAccent;
      } else {
        displayEvent["color"] = Color(0xff69d1c5);
      }
      diaplayEventsList.add(displayEvent);
    }
  }

  Map<String, dynamic> findCurrentEvent(String currentId) {
    Map<String, dynamic> return_event = {};
    bool found = false;
    int length = widget.eventsMap.length;
    for (int i = 0; i < length && !found; i++) {
      if (widget.eventsMap[i]["id"] == currentId) {
        return_event = widget.eventsMap[i];
      }
    }
    return return_event;
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Map<String, dynamic>> eventsMap) {
    appointments = eventsMap.map((eventMap) {
      return Appointment(
        id: eventMap["id"],
        startTime: eventMap["startTime"],
        endTime: eventMap["endTime"],
        subject: eventMap["title"],
        color: eventMap["color"], // Customize color as needed
      );
    }).toList();
  }
}

class EventDialogBox extends StatefulWidget {
  final Map<String, dynamic> currentEventMap;
  final bool isAdmin;
  const EventDialogBox(
      {required this.currentEventMap, required this.isAdmin, super.key});

  @override
  State<EventDialogBox> createState() => _EventDialogBoxState();
}

class _EventDialogBoxState extends State<EventDialogBox> {
  // bool? isAdmin;
  TextEditingController otpTextField = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    otpTextField.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.currentEventMap);
    // String user = "Guest";
    DateTime currentEventDate =
        DateTime.parse(widget.currentEventMap["eventDate"]);
    // int currentStartTime = int.parse(widget.currentEventMap["startTime"]);
    // int currentEndTime = int.parse(widget.currentEventMap["endTime"]);
    DateTime currentStartTime =
        DateTime.parse(widget.currentEventMap["startTime"]);
    DateTime currentEndTime = DateTime.parse(widget.currentEventMap["endTime"]);
    //TODO if not using currentstarttime and end time as datetime, remove the .hour from the below code
    String currentStartTimeString =
        "${currentStartTime.hour <= 12 ? currentStartTime.hour : currentStartTime.hour - 12}:00 ${currentStartTime.hour < 12 ? "AM" : "PM"}";
    String currentEndTimeString =
        "${currentEndTime.hour <= 12 ? currentEndTime.hour : currentEndTime.hour - 12}:00 ${currentEndTime.hour < 12 ? "AM" : "PM"}";
    String statusString;
    if (widget.currentEventMap["status"] == "Booked") {
      statusString = "Booked";
    } else if (widget.currentEventMap["status"] == "inUse") {
      statusString = "In Use";
    } else {
      statusString = "Free";
    }
    return AlertDialog(
      backgroundColor: backgroundColor,
      titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 10),
      title: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 48,
              child: Center(
                child: Visibility(
                  visible: widget.isAdmin,
                  child: IconButton(
                      onPressed: () async {
                        bool eventDeleted =
                            await deleteEvent(widget.currentEventMap["id"]);
                        if (eventDeleted) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 24,
                      )),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "${widget.currentEventMap["eventName"]}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: prussianBlue),
                ),
              ),
            ),
            SizedBox(
              width: 48,
              child: Center(
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 24,
                    )),
              ),
            ),
          ],
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextRichEventDialog(
            heading: "Organiser",
            value: widget.currentEventMap["organiserName"],
          ),
          TextRichEventDialog(
            heading: "Mobile No.",
            value: widget.currentEventMap["mobileNumber"],
          ),
          TextRichEventDialog(
              heading: "Event Date",
              value:
                  "${currentEventDate.day}-${currentEventDate.month}-${currentEventDate.year}"),
          TextRichEventDialog(
              heading: "Start Time", value: currentStartTimeString),
          TextRichEventDialog(heading: "End Time", value: currentEndTimeString),
          TextRichEventDialog(heading: "Status", value: statusString),
          if (!widget.isAdmin && widget.currentEventMap["status"] != "free")
            const SizedBox(
              height: 10,
            ),
          if (!widget.isAdmin && widget.currentEventMap["status"] == "Booked")
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    cursorColor: prussianBlue,
                    controller: otpTextField,
                    decoration: textfieldstyle1(Icons.lock_outlined, "OTP"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // fixedSize: Size(400, 50),
                        fixedSize: Size(double.infinity,
                            MediaQuery.of(context).size.height * 0.06),
                        backgroundColor: prussianBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          // Rounded corners
                        ),
                        elevation: 5, // Elevation (shadow)
                      ),
                      onPressed: () async {
                        bool otpVerified = await verifyOtp(
                            widget.currentEventMap["id"],
                            otpTextField.text.trim());
                        if (otpVerified) {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 16,
                          color: backgroundColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          if (!widget.isAdmin && widget.currentEventMap["status"] == "inUse")
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                onPressed: () async {
                  bool keysReturned =
                      await returnKeys(widget.currentEventMap["id"]);
                  if (keysReturned) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  //TODO set the size accordingly
                  backgroundColor: prussianBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    // Rounded corners
                  ),
                  elevation: 5, // Elevation (shadow)
                ),
                child: Text(
                  'Return Keys',
                  style: TextStyle(
                    fontSize: 16,
                    color: backgroundColor,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Future<bool> deleteEvent(String id) async {
    bool deleted = false;
    String snakbarText = "Failed to delete";
    print(id);
    try {
      //TODO delete here
      // ApiService().deleteData(id);
      final provider =
          navigatorKey.currentState!.context.read<UserStatusProvider>();
      provider.deleteEventDataById(id);
      deleted = true;
      snakbarText = "Event deleted";
    } catch (e) {
      snakbarText = "NetWork Error";
      print(e);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(snakbarText),
    );
    return deleted;
  }

  Future<bool> verifyOtp(String id, String EnteredOtp) async {
    bool verified = false;
    String snakbarText = "Wrong Otp";
    //TODO check enteered otp
    if (EnteredOtp == "1821") {
      try {
        final provider =
            navigatorKey.currentState!.context.read<UserStatusProvider>();
        provider.updateEventStatusById(id, "inUse");
        verified = true;
        snakbarText = "Otp Verified";
      } catch (e) {
        snakbarText = "NetWork Error";
        debugPrint("$e");
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(snakbarText),
    );
    return verified;
  }

  Future<bool> returnKeys(String id) async {
    bool keysReturned = false;
    String snakbarText = "Keys Not Returned";
    try {
      final provider =
          navigatorKey.currentState!.context.read<UserStatusProvider>();
      provider.updateEventStatusById(id, "free");
      snakbarText = "Keys Returned";
      keysReturned = true;
    } catch (e) {
      snakbarText = "NetWork Error";
      debugPrint("$e");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(snakbarText),
    );
    return keysReturned;
  }
}

class TextRichEventDialog extends StatelessWidget {
  final String heading;
  final String value;
  const TextRichEventDialog(
      {required this.heading, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$heading : ', // Default style for this span
        style: TextStyle(
            fontWeight: FontWeight.bold, color: prussianBlue, fontSize: 14),
        children: [
          TextSpan(
            text: value,
            style:
                TextStyle(fontWeight: FontWeight.normal, color: prussianBlue),
          ),
        ],
      ),
      softWrap: true, //allows wrapping of text to next line if width is less
    );
  }
}
