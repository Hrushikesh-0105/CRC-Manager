// import 'package:crc_app/Api/api.dart';
import 'package:crc_app/CustomWidgets/event_dialog_box.dart';
import 'package:crc_app/main.dart';
import 'package:crc_app/styles.dart';
import 'package:crc_app/userStatusProvider/user_and_event_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:crc_app/userStatusProvider/db_keys_room_status.dart';

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
      backgroundColor: backgroundColor,
      minDate: DateTime(widget.currentDate.year, widget.currentDate.month,
          widget.currentDate.day, 8),
      maxDate: DateTime(widget.currentDate.year, widget.currentDate.month,
          widget.currentDate.day, 20),
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 7.0,
        endHour: 21.0,
        timeIntervalHeight: 60,
        timeInterval: Duration(hours: 1),
      ),
      selectionDecoration: BoxDecoration(
        border: Border.all(
          color: prussianBlue,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      todayHighlightColor: prussianBlue,
      onTap: (CalendarTapDetails details) {
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
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  void createDisplayEventsMap() {
    logDebugMsg("entered create displayevents function");
    // logDebugMsg(widget.eventsMap);
    for (Map<String, dynamic> event in widget.eventsMap) {
      Map<String, dynamic> displayEvent = {};
      displayEvent[DBKeys.id] = event[DBKeys.id];
      displayEvent[DBKeys.eventName] = event[DBKeys.eventName];
      displayEvent[DBKeys.startTime] = DateTime.parse(event[DBKeys.startTime]);
      displayEvent[DBKeys.endTime] = DateTime.parse(event[DBKeys.endTime]);
      if (event[DBKeys.status] == RoomStatus.booked) {
        displayEvent["color"] = Colors.orangeAccent;
      } else if (event[DBKeys.status] == RoomStatus.inUse) {
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
      if (widget.eventsMap[i][DBKeys.id] == currentId) {
        returnEvent = widget.eventsMap[i];
      }
    }
    return returnEvent;
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Map<String, dynamic>> eventsMapList) {
    appointments = eventsMapList.map((eventMap) {
      logDebugMsg("id is: ${eventMap[DBKeys.id]}");
      return Appointment(
        id: "${eventMap[DBKeys.id]}",
        startTime: eventMap[DBKeys.startTime],
        endTime: eventMap[DBKeys.endTime],
        subject: eventMap[DBKeys.eventName] ?? "null",
        color: eventMap["color"],
      );
    }).toList();
  }
}

void logDebugMsg(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
