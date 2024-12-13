// import 'package:crc_app/Api/api.dart';
import 'package:crc_app/Api/api.dart';
import 'package:crc_app/CustomWidgets/snack_bar.dart';
import 'package:crc_app/main.dart';
import 'package:crc_app/styles.dart';
import 'package:crc_app/userStatusProvider/user_and_event_provider.dart';
import 'package:flutter/foundation.dart';
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
    // logDebugMsg("Events map:  ${widget.eventsMap}");
    createDisplayEventsMap();
  }

  @override
  void didUpdateWidget(CalandarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    //! Rebuilds when data changes
    diaplayEventsList.clear(); // Clear the old list
    createDisplayEventsMap();
    setState(() {});
  }

  //test
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      headerHeight: 0,
      viewHeaderHeight: 0,
      //changes
      // view: CalendarView.day,

      // scheduleViewSettings: const ScheduleViewSettings(
      //     hideEmptyScheduleWeek: true,
      //     monthHeaderSettings: MonthHeaderSettings(
      //       height: 0,
      //     ),
      //     weekHeaderSettings: WeekHeaderSettings(height: 0)),
      //changes
      backgroundColor: backgroundColor,
      minDate: DateTime(widget.currentDate.year, widget.currentDate.month,
          widget.currentDate.day, 8),
      maxDate: DateTime(widget.currentDate.year, widget.currentDate.month,
          widget.currentDate.day, 20),
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 7.0, // Start displaying from 8 am
        endHour: 21.0, // End displaying at 8 pm
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
        logDebugMsg("${details.appointments}");
        String currentId = details.appointments![0].id;
        Map<String, dynamic> currentEvent = findCurrentEvent(currentId);
        // logDebugMsg(currentEvent);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return EventDialogBox(
                  currentEventMap: currentEvent, isAdmin: isAdmin!);
            });
      },
      dataSource: EventDataSource(diaplayEventsList),
      appointmentTextStyle: const TextStyle(
        fontSize: 14, // Custom font size
        fontWeight: FontWeight.bold, // Custom font weight
        color: Colors.white, // Text color
      ),
    );
  }

  void createDisplayEventsMap() {
    logDebugMsg("entered create displayevents function");
    // logDebugMsg(widget.eventsMap);
    for (Map<String, dynamic> event in widget.eventsMap) {
      Map<String, dynamic> displayEvent = {};
      // DateTime eventDate = DateTime.parse(event["Date"]);
      // int startTime = int.parse(event["BookedFrom"]);
      // int endTime = int.parse(event["BookedTill"]);
      displayEvent["_id"] = event["_id"];
      logDebugMsg(event["_id"]);
      displayEvent["title"] = event["EventName"];
      // displayEvent["BookedFrom"] =
      //     DateTime(eventDate.year, eventDate.month, eventDate.day, startTime);
      // displayEvent["BookedTill"] =
      //     DateTime(eventDate.year, eventDate.month, eventDate.day, endTime);
      displayEvent["BookedFrom"] = DateTime.parse(event["BookedFrom"]);
      displayEvent["BookedTill"] = DateTime.parse(event["BookedTill"]);
      if (event["Status"] == "booked") {
        displayEvent["color"] = Colors.orangeAccent;
      } else if (event["Status"] == "inUse") {
        displayEvent["color"] = Colors.redAccent;
      } else {
        displayEvent["color"] = Colors.grey;
      }
      diaplayEventsList.add(displayEvent);
    }
  }

  Map<String, dynamic> findCurrentEvent(String currentId) {
    Map<String, dynamic> returnEvent = {};
    bool found = false;
    int length = widget.eventsMap.length;
    for (int i = 0; i < length && !found; i++) {
      if (widget.eventsMap[i]["_id"] == currentId) {
        returnEvent = widget.eventsMap[i];
      }
    }
    return returnEvent;
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Map<String, dynamic>> eventsMap) {
    appointments = eventsMap.map((eventMap) {
      //!error here
      logDebugMsg("id is: ${eventMap["_id"]}");
      return Appointment(
        id: "${eventMap["_id"]}",
        startTime: eventMap["BookedFrom"],
        endTime: eventMap["BookedTill"],
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
    logDebugMsg("Entered event dialog box");
    otpTextField.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      logDebugMsg("${widget.currentEventMap}");
    }
    // String user = "Guest";
    DateTime currentEventDate = DateTime.parse(widget.currentEventMap["Date"]);
    // logDebugMsg(widget.currentEventMap);
    // int currentStartTime = int.parse(widget.currentEventMap["BookedFrom"]);
    // int currentEndTime = int.parse(widget.currentEventMap["BookedTill"]);
    DateTime currentStartTime =
        DateTime.parse(widget.currentEventMap["BookedFrom"]);
    DateTime currentEndTime =
        DateTime.parse(widget.currentEventMap["BookedTill"]);
    //TODO if not using currentstarttime and end time as datetime, remove the .hour from the below code
    String currentStartTimeString =
        "${currentStartTime.hour <= 12 ? currentStartTime.hour : currentStartTime.hour - 12}:00 ${currentStartTime.hour < 12 ? "AM" : "PM"}";
    String currentEndTimeString =
        "${currentEndTime.hour <= 12 ? currentEndTime.hour : currentEndTime.hour - 12}:00 ${currentEndTime.hour < 12 ? "AM" : "PM"}";
    String statusString;
    if (widget.currentEventMap["Status"] == "booked") {
      statusString = "booked";
    } else if (widget.currentEventMap["Status"] == "inUse") {
      statusString = "In Use";
    } else {
      statusString = "Free";
    }
    String currentId = widget.currentEventMap["_id"];
    String currentOTP = currentId.substring(currentId.length - 4);
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
                        bool eventDeleted = await deleteEvent(currentId);
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
                  "${widget.currentEventMap["EventName"]}",
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
            value: widget.currentEventMap["OrganiserName"],
          ),
          TextRichEventDialog(
            heading: "Mobile No.",
            //todo change to the actual mobile number from map
            //widget.currentEventMap["MobileNumber"]
            value: "947808844",
          ),
          TextRichEventDialog(
              heading: "Event Date",
              value:
                  "${currentEventDate.day}-${currentEventDate.month}-${currentEventDate.year}"),
          TextRichEventDialog(
              heading: "Start Time", value: currentStartTimeString),
          TextRichEventDialog(heading: "End Time", value: currentEndTimeString),
          TextRichEventDialog(heading: "Status", value: statusString),
          if (widget.isAdmin)
            TextRichEventDialog(heading: "OTP", value: currentOTP),
          if (!widget.isAdmin && widget.currentEventMap["Status"] != "free")
            const SizedBox(
              height: 10,
            ),
          if (!widget.isAdmin && widget.currentEventMap["Status"] == "booked")
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
                            widget.currentEventMap["_id"],
                            otpTextField.text.trim(),
                            currentOTP);
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
          if (!widget.isAdmin && widget.currentEventMap["Status"] == "inUse")
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                onPressed: () async {
                  bool keysReturned =
                      await returnKeys(widget.currentEventMap["_id"]);
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
    SnackbarType snakbarTextType = SnackbarType.error;
    bool eventDeleted;
    String snakbarText = "Failed to delete";
    if (kDebugMode) {
      logDebugMsg(id);
    }
    try {
      //TODO delete here

      eventDeleted = await ApiService().deleteData(id);
      if (eventDeleted) {
        final provider =
            navigatorKey.currentState!.context.read<UserStatusProvider>();
        provider.deleteEventDataById(id);
        logDebugMsg("Deleted successfully");
        snakbarText = "Event deleted";
      }
    } catch (e) {
      snakbarText = "NetWork Error";
      eventDeleted = false;
      if (kDebugMode) {
        logDebugMsg("$e");
      }
    }
    if (eventDeleted) snakbarTextType = SnackbarType.success;
    showSnackBar(context, snakbarText, snakbarTextType);
    return eventDeleted;
  }

  Future<bool> verifyOtp(String id, String enteredOtp, String actualOtp) async {
    SnackbarType snakbarTextType = SnackbarType.error;
    bool verified = false;
    String snakbarText = "Wrong Otp";
    //TODO check enteered otp
    if (enteredOtp == actualOtp) {
      try {
        verified = await ApiService().updateBookingStatus(id, "inUse");
        if (verified) {
          final provider =
              navigatorKey.currentState!.context.read<UserStatusProvider>();
          provider.updateEventStatusById(id, "inUse");
          snakbarText = "Otp Verified";
        } else {
          snakbarText = "NetWork Error";
        }
      } catch (e) {
        snakbarText = "NetWork Error";
        logDebugMsg("$e");
      }
    }
    if (verified) snakbarTextType = SnackbarType.success;
    showSnackBar(context, snakbarText, snakbarTextType);
    return verified;
  }

  Future<bool> returnKeys(String id) async {
    SnackbarType snakbarTextType = SnackbarType.error;
    bool keysReturned = false;
    String snakbarText = "Keys Not Returned";
    try {
      keysReturned = await ApiService().updateBookingStatus(id, "free");
      if (keysReturned) {
        final provider =
            navigatorKey.currentState!.context.read<UserStatusProvider>();
        provider.updateEventStatusById(id, "free");
        snakbarText = "Keys Returned";
      }
    } catch (e) {
      snakbarText = "NetWork Error";
      logDebugMsg("$e");
    }
    if (keysReturned) snakbarTextType = SnackbarType.success;
    showSnackBar(context, snakbarText, snakbarTextType);
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
