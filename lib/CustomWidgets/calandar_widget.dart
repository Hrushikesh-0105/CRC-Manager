import 'package:crc_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:crc_app/pages/events_page.dart';

class CalandarWidget extends StatefulWidget {
  final DateTime currentDate;
  final List<Event> events;
  const CalandarWidget(
      {required this.currentDate, required this.events, super.key});

  @override
  State<CalandarWidget> createState() => _CalandarWidgetState();
}

class _CalandarWidgetState extends State<CalandarWidget> {
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
        endHour: 21, // End displaying at 8 p.m.
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
      // cellBorderColor: prussianBlue,
      //data
      dataSource: EventDataSource(widget.events),
    );
  }
}
