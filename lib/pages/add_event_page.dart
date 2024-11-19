import 'dart:developer';
import 'package:crc_app/Api/api.dart';
import 'package:crc_app/CustomWidgets/floor_classroom_widget.dart';
import 'package:crc_app/pages/events_page.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';
// import 'package:crc_app/pages/thirdPage.dart';
import 'package:crc_app/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddEventPage extends StatefulWidget {
  final floorNumber;
  final roomNumber;
  final DateTime eventDate;
  final List<Map<String, DateTime>> currentEventTimes;
  const AddEventPage(
      {required this.eventDate,
      required this.floorNumber,
      required this.roomNumber,
      required this.currentEventTimes,
      super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  //textfield controllers
  TextEditingController eventnameTextField = TextEditingController();
  TextEditingController organiserNameTextField = TextEditingController();
  TextEditingController mobileNumberTextField = TextEditingController();
  TextEditingController eventDateTextField = TextEditingController();
  TextEditingController eventStartTimeTextField = TextEditingController();
  TextEditingController eventEndTimeTextField = TextEditingController();
  TextEditingController classroomTextField = TextEditingController();

  //textfield colors

  //date and time
  // DateTime? eventDate;
  List<DateTime> possibleStartTimes = [];
  List<DateTime> possibleEndTimes = [];
  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    possibleStartTimes = generatePossibleStartTimes(widget.currentEventTimes);
  }

  @override
  Widget build(BuildContext context) {
    classroomTextField.text = "${widget.floorNumber}-${widget.roomNumber}";
    eventDateTextField.text =
        "${widget.eventDate.day}/${widget.eventDate.month}/${widget.eventDate.year}";
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double boxPadding = deviceWidth * 0.05;
    return Padding(
      padding: EdgeInsets.only(
        // Add padding for the keyboard
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: deviceWidth,
        height: deviceHeight * 0.6,
        padding: EdgeInsets.all(boxPadding),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //event name textfield
                TextFormField(
                  controller: eventnameTextField,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  decoration:
                      textfieldstyle1(Icons.event_note_outlined, "Event Name"),
                  style: style1(),
                  cursorColor: prussianBlue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: organiserNameTextField,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  decoration: textfieldstyle1(
                      Icons.person_outline_rounded, "Organiser Name"),
                  style: style1(),
                  cursorColor: prussianBlue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: mobileNumberTextField,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration:
                      textfieldstyle1(Icons.call_outlined, "Mobile Number"),
                  style: style1(),
                  cursorColor: prussianBlue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field cannot be empty";
                    } else if (value.length != 10) {
                      return "Enter 10 digit mobile number";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: eventDateTextField,
                  readOnly: true,
                  decoration: textfieldstyle1(
                      Icons.edit_calendar_rounded, "Event Date"),
                  style: style1(),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<DateTime>(
                        value: _selectedStartTime,
                        // isExpanded: true,
                        decoration:
                            textfieldstyle1(Icons.timer_sharp, "Start Time"),
                        itemHeight: 56,
                        items: possibleStartTimes.isNotEmpty
                            ? possibleStartTimes.map((time) {
                                // Convert the time to a 12-hour format and append AM/PM
                                int displayHour = time.hour %
                                    12; // Converts hour to 12-hour format
                                displayHour = displayHour == 0
                                    ? 12
                                    : displayHour; // Handle 12 AM/PM
                                String amPm = time.hour < 12 ? 'AM' : 'PM';

                                return DropdownMenuItem<DateTime>(
                                  value: time,
                                  child: Text(
                                    "${displayHour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $amPm",
                                    style: style1(),
                                  ),
                                );
                              }).toList()
                            : [
                                DropdownMenuItem<DateTime>(
                                  value: null,
                                  child: Text(
                                    "NA",
                                    style: style1(),
                                  ),
                                )
                              ],
                        onChanged: possibleStartTimes.isNotEmpty
                            ? (value) {
                                setState(() {
                                  _selectedStartTime = value;
                                  possibleEndTimes.clear();
                                  _selectedEndTime = null;
                                  possibleEndTimes = generatePossibleEndTimes(
                                      value!, widget.currentEventTimes);
                                  if (kDebugMode) {
                                    print(possibleEndTimes);
                                  }
                                });
                              }
                            : null,
                        validator: (value) =>
                            value == null ? "Please select a start time" : null,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    //end time drop down
                    Expanded(
                      child: DropdownButtonFormField<DateTime>(
                        value: _selectedEndTime,

                        decoration: textfieldstyle1(
                            Icons.timer_off_outlined, "End Time"),
                        itemHeight: 56,
                        items: possibleEndTimes
                                .isNotEmpty // Check if the list is not empty
                            ? possibleEndTimes.map((time) {
                                int displayHour = time.hour % 12;
                                displayHour =
                                    displayHour == 0 ? 12 : displayHour;
                                String amPm = time.hour < 12 ? 'AM' : 'PM';
                                return DropdownMenuItem<DateTime>(
                                  value: time,
                                  child: Text(
                                    "${displayHour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $amPm",
                                    style: style1(),
                                  ),
                                );
                              }).toList()
                            : [
                                DropdownMenuItem<DateTime>(
                                  value: null,
                                  child: Text(
                                    "NA",
                                    style: style1(),
                                  ),
                                )
                              ],
                        onChanged: possibleEndTimes
                                .isNotEmpty // Enable only if the list is not empty
                            ? (value) {
                                setState(() {
                                  _selectedEndTime = value;
                                });
                              }
                            : null, // Disable dropdown if list is empty
                        validator: (value) =>
                            value == null ? "Please select an end time" : null,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: classroomTextField,
                  enabled: false,
                  decoration: textfieldstyle1(Icons.room_outlined, "Classroom"),
                  style: style1(),
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool eventCreated = await _createEvent();
                    if (eventCreated) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(deviceWidth - 2 * boxPadding, deviceHeight * 0.06),
                    backgroundColor: prussianBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // Rounded corners
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Create Event',
                    style: TextStyle(fontSize: 18, color: backgroundColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DateTime> generatePossibleStartTimes(
      List<Map<String, DateTime>> eventTimes) {
    // Define the event window: 8:00 AM to 8:00 PM
    DateTime eventDate = widget.eventDate;

    eventTimes.sort((a, b) => a['startTime']!.compareTo(b['startTime']!));
    print(eventTimes);

    List<DateTime> totalStartTimes = [];
    for (int i = 8; i <= 19; i++) {
      totalStartTimes
          .add(DateTime(eventDate.year, eventDate.month, eventDate.day, i));
    }
    //merging the event times
    int mergeIndex = 0;
    int eventTimesLength = eventTimes.length;
    while (mergeIndex != eventTimesLength - 1) {
      if (eventTimes[mergeIndex]["endTime"]!
          .isAtSameMomentAs(eventTimes[mergeIndex + 1]["startTime"]!)) {
        eventTimes[mergeIndex]["endTime"] =
            eventTimes[mergeIndex + 1]["endTime"]!;
        eventTimes.removeAt(mergeIndex + 1);
        eventTimesLength = eventTimesLength - 1;
      } else {
        mergeIndex = mergeIndex + 1;
      }
    }
    print(eventTimes);
    List<DateTime> StartTimes = [];
    int eventPointer = 0;
    //checking  event times
    for (int i = 0; i < 12; i++) {
      if (eventPointer >= eventTimesLength) {
        StartTimes.add(totalStartTimes[i]);
      } else if (totalStartTimes[i]
          .isBefore(eventTimes[eventPointer]["startTime"]!)) {
        StartTimes.add(totalStartTimes[i]);
      } else if (totalStartTimes[i] == eventTimes[eventPointer]["endTime"]! ||
          totalStartTimes[i].isAfter(eventTimes[eventPointer]["endTime"]!)) {
        StartTimes.add(totalStartTimes[i]);
        eventPointer++;
      }
    }
    print(StartTimes);
    return StartTimes;
  }

  List<DateTime> generatePossibleEndTimes(
      DateTime selectedStartTime, List<Map<String, DateTime>> eventTimes) {
    // DateTime eventDate = widget.eventDate;

    eventTimes.sort((a, b) => a['startTime']!.compareTo(b['startTime']!));
    // print(eventTimes);

    //merging the event times
    int mergeIndex = 0;
    int eventTimesLength = eventTimes.length;
    while (mergeIndex != eventTimesLength - 1) {
      if (eventTimes[mergeIndex]["endTime"]!
          .isAtSameMomentAs(eventTimes[mergeIndex + 1]["startTime"]!)) {
        eventTimes[mergeIndex]["endTime"] =
            eventTimes[mergeIndex + 1]["endTime"]!;
        eventTimes.removeAt(mergeIndex + 1);
        eventTimesLength = eventTimesLength - 1;
      } else {
        mergeIndex = mergeIndex + 1;
      }
    }
    if (kDebugMode) {
      print(eventTimes);
    }
    List<DateTime> EndTimes = [];
    DateTime? lastEndTime;

    bool endTimeFound = false;
    for (int i = 0; i < eventTimesLength && !endTimeFound; i++) {
      if (selectedStartTime.isBefore(eventTimes[i]["startTime"]!)) {
        lastEndTime = eventTimes[i]["startTime"]!;
        endTimeFound = true;
      }
    }
    if (!endTimeFound) {
      lastEndTime = DateTime(selectedStartTime.year, selectedStartTime.month,
          selectedStartTime.day, 20); //last end time is 8 pm==20
    }
    for (int i = selectedStartTime.hour + 1; i <= lastEndTime!.hour; i++) {
      EndTimes.add(DateTime(selectedStartTime.year, selectedStartTime.month,
          selectedStartTime.day, i));
    }
    return EndTimes;
  }

  Future<bool> _createEvent() async {
    bool eventCreated = false;
    print("entered function");
    if (_formKey.currentState!.validate()) {
      String eventDateString = widget.eventDate.toString();
      String startTimeString = _selectedStartTime.toString();
      String endTimeString = _selectedEndTime.toString();
      String eventNameString = eventnameTextField.text.trim();
      String organiserNameString = organiserNameTextField.text.trim();
      String mobileNumberString = mobileNumberTextField.text.trim();
      int selectedFloor = widget.floorNumber;
      int selectedRoom = widget.roomNumber;

      Map<String, dynamic> eventMap = {
        "eventName": eventNameString,
        "organiserName": organiserNameString,
        "mobileNumber": mobileNumberString,
        "eventDate": eventDateString,
        "startTime": startTimeString,
        "endTime": endTimeString,
        "roomName": "$selectedFloor-$selectedRoom",
        "status": false,
      };

      // var connectivityResult = await Connectivity().checkConnectivity();

      // print("connectivity: ${connectivityResult == ConnectivityResult.mobile}");

      // if (connectivityResult == ConnectivityResult.mobile ||
      //     connectivityResult == ConnectivityResult.wifi) {
      //   if (kDebugMode) {
      //     print("Connected to Mobile Network");
      //   }
      // } else {
      //   if (mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content: Text("You are Offline"),
      //       duration: const Duration(milliseconds: 500),
      //     ));
      //   }
      //   eventCreated = false;
      // }

      //TODO send data here
      // try {
      //   ApiService().postData(eventMap);
      // } catch (e) {
      //   if (kDebugMode) {
      //     print(e);
      //   }
      // }
    }
    return false;
  }
}
