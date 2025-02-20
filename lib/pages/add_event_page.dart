import 'package:auto_size_text/auto_size_text.dart';
import 'package:crc_app/CustomWidgets/snack_bar.dart';
import 'package:flutter_native_sms/flutter_native_sms.dart';
import 'package:intl/intl.dart';
import 'package:crc_app/Api/api.dart';
import 'package:crc_app/main.dart';
import 'package:crc_app/userStatusProvider/user_and_event_provider.dart';
import 'package:crc_app/userStatusProvider/db_keys_room_status.dart';
import 'package:crc_app/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatefulWidget {
  final String roomName;
  final DateTime eventDate;
  final List<Map<String, DateTime>> currentEventTimes;
  const AddEventPage(
      {required this.eventDate,
      required this.roomName,
      required this.currentEventTimes,
      super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //textfield controllers
  final TextEditingController _eventnameTextField = TextEditingController();
  final TextEditingController _organiserNameTextField = TextEditingController();
  final TextEditingController _mobileNumberTextField = TextEditingController();
  final TextEditingController _eventDateTextField = TextEditingController();
  final TextEditingController _classroomTextField = TextEditingController();

  //date and time
  List<DateTime> _possibleStartTimes = [];
  List<DateTime> _possibleEndTimes = [];
  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _possibleStartTimes = generatePossibleStartTimes(widget.currentEventTimes);
  }

  @override
  void dispose() {
    super.dispose();
    disposeControllers([
      _eventnameTextField,
      _organiserNameTextField,
      _mobileNumberTextField,
      _eventDateTextField,
      _classroomTextField,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _classroomTextField.text = widget.roomName;
    _eventDateTextField.text =
        DateFormat('dd-MM-yyyy').format(widget.eventDate);
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double boxPadding = deviceWidth * 0.05;
    return Padding(
      padding: EdgeInsets.only(
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
                TextFormField(
                  controller: _eventnameTextField,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  decoration: textfieldstyle1(
                      prefixicon: Icons.event_note_outlined,
                      hinttext: "Event Name"),
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
                  controller: _organiserNameTextField,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  decoration: textfieldstyle1(
                      prefixicon: Icons.person_outline_rounded,
                      hinttext: "Organiser Name"),
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
                  controller: _mobileNumberTextField,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: textfieldstyle1(
                      prefixicon: Icons.call_outlined,
                      hinttext: "Mobile Number"),
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
                  controller: _eventDateTextField,
                  readOnly: true,
                  decoration: textfieldstyle1(
                      prefixicon: Icons.edit_calendar_rounded,
                      hinttext: "Event Date"),
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
                        decoration: textfieldstyle1(
                            prefixicon: Icons.timer_sharp,
                            hinttext: "Start Time"),
                        itemHeight: 56,
                        items: _possibleStartTimes.isNotEmpty
                            ? _possibleStartTimes.map((time) {
                                int displayHour = time.hour % 12;
                                displayHour = displayHour == 0
                                    ? 12
                                    : displayHour; // Handle 12 AM/PM
                                String amPm = time.hour < 12 ? 'AM' : 'PM';

                                return DropdownMenuItem<DateTime>(
                                  value: time,
                                  child: AutoSizeText(
                                    "${displayHour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $amPm",
                                    style: style1(),
                                  ),
                                );
                              }).toList()
                            : [
                                DropdownMenuItem<DateTime>(
                                  value: null,
                                  child: AutoSizeText(
                                    "NA",
                                    style: style1(),
                                  ),
                                )
                              ],
                        onChanged: _possibleStartTimes.isNotEmpty
                            ? (value) {
                                setState(() {
                                  _selectedStartTime = value;
                                  _possibleEndTimes.clear();
                                  _selectedEndTime = null;
                                  _possibleEndTimes = generatePossibleEndTimes(
                                      value!, widget.currentEventTimes);
                                  if (kDebugMode) {
                                    print(_possibleEndTimes);
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
                    Expanded(
                      child: DropdownButtonFormField<DateTime>(
                        value: _selectedEndTime,
                        decoration: textfieldstyle1(
                            prefixicon: Icons.timer_off_outlined,
                            hinttext: "End Time"),
                        itemHeight: 56,
                        items: _possibleEndTimes.isNotEmpty
                            ? _possibleEndTimes.map((time) {
                                int displayHour = time.hour % 12;
                                displayHour =
                                    displayHour == 0 ? 12 : displayHour;
                                String amPm = time.hour < 12 ? 'AM' : 'PM';
                                return DropdownMenuItem<DateTime>(
                                  value: time,
                                  child: AutoSizeText(
                                    "${displayHour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $amPm",
                                    style: style1(),
                                  ),
                                );
                              }).toList()
                            : [
                                DropdownMenuItem<DateTime>(
                                  value: null,
                                  child: AutoSizeText(
                                    "NA",
                                    style: style1(),
                                  ),
                                )
                              ],
                        onChanged: _possibleEndTimes.isNotEmpty
                            ? (value) {
                                setState(() {
                                  _selectedEndTime = value;
                                });
                              }
                            : null,
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
                  controller: _classroomTextField,
                  enabled: false,
                  decoration: textfieldstyle1(
                      prefixicon: Icons.room_outlined, hinttext: "Classroom"),
                  style: style1(),
                ),
                const SizedBox(
                  height: 12,
                ),
                _isLoading
                    ? loadingIndicatorWidget()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          bool eventCreated = await _createEvent();
                          if (eventCreated) {
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(deviceWidth - 2 * boxPadding,
                              deviceHeight * 0.06),
                          backgroundColor: prussianBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                        child: AutoSizeText(
                          'Create Event',
                          style:
                              TextStyle(fontSize: 18, color: backgroundColor),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loadingIndicatorWidget() {
    return Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: prussianBlue,
        ),
      ),
    );
  }

  List<DateTime> generatePossibleStartTimes(
      List<Map<String, DateTime>> eventTimes) {
    List<DateTime> startTimes = [];
    DateTime eventDate = widget.eventDate;
    if (eventTimes.isEmpty) {
      for (int i = 8; i <= 19; i++) {
        startTimes
            .add(DateTime(eventDate.year, eventDate.month, eventDate.day, i));
      }
    } else {
      eventTimes
          .sort((a, b) => a[DBKeys.startTime]!.compareTo(b[DBKeys.startTime]!));
      if (kDebugMode) {
        print(eventTimes);
      }

      List<DateTime> totalStartTimes = [];
      for (int i = 8; i <= 19; i++) {
        totalStartTimes
            .add(DateTime(eventDate.year, eventDate.month, eventDate.day, i));
      }
      int mergeIndex = 0;
      int eventTimesLength = eventTimes.length;
      while (mergeIndex != eventTimesLength - 1) {
        if (eventTimes[mergeIndex][DBKeys.endTime]!
            .isAtSameMomentAs(eventTimes[mergeIndex + 1][DBKeys.startTime]!)) {
          eventTimes[mergeIndex][DBKeys.endTime] =
              eventTimes[mergeIndex + 1][DBKeys.endTime]!;
          eventTimes.removeAt(mergeIndex + 1);
          eventTimesLength = eventTimesLength - 1;
        } else {
          mergeIndex = mergeIndex + 1;
        }
      }
      if (kDebugMode) {
        print(eventTimes);
      }

      int eventPointer = 0;
      //checking  event times
      for (int i = 0; i < 12; i++) {
        if (eventPointer >= eventTimesLength) {
          startTimes.add(totalStartTimes[i]);
        } else if (totalStartTimes[i]
            .isBefore(eventTimes[eventPointer][DBKeys.startTime]!)) {
          startTimes.add(totalStartTimes[i]);
        } else if (totalStartTimes[i] ==
                eventTimes[eventPointer][DBKeys.endTime]! ||
            totalStartTimes[i]
                .isAfter(eventTimes[eventPointer][DBKeys.endTime]!)) {
          startTimes.add(totalStartTimes[i]);
          eventPointer++;
        }
      }
    }
    if (kDebugMode) {
      print(startTimes);
    }
    return startTimes;
  }

  List<DateTime> generatePossibleEndTimes(
      DateTime selectedStartTime, List<Map<String, DateTime>> eventTimes) {
    List<DateTime> endTimes = [];
    if (eventTimes.isEmpty) {
      for (int i = selectedStartTime.hour + 1; i <= 20; i++) {
        endTimes.add(DateTime(selectedStartTime.year, selectedStartTime.month,
            selectedStartTime.day, i));
      }
    } else {
      eventTimes
          .sort((a, b) => a[DBKeys.startTime]!.compareTo(b[DBKeys.startTime]!));
      int mergeIndex = 0;
      int eventTimesLength = eventTimes.length;
      while (mergeIndex != eventTimesLength - 1) {
        if (eventTimes[mergeIndex][DBKeys.endTime]!
            .isAtSameMomentAs(eventTimes[mergeIndex + 1][DBKeys.startTime]!)) {
          eventTimes[mergeIndex][DBKeys.endTime] =
              eventTimes[mergeIndex + 1][DBKeys.endTime]!;
          eventTimes.removeAt(mergeIndex + 1);
          eventTimesLength = eventTimesLength - 1;
        } else {
          mergeIndex = mergeIndex + 1;
        }
      }
      if (kDebugMode) {
        print(eventTimes);
      }

      DateTime? lastEndTime;

      bool endTimeFound = false;
      for (int i = 0; i < eventTimesLength && !endTimeFound; i++) {
        if (selectedStartTime.isBefore(eventTimes[i][DBKeys.startTime]!)) {
          lastEndTime = eventTimes[i][DBKeys.startTime]!;
          endTimeFound = true;
        }
      }
      if (!endTimeFound) {
        lastEndTime = DateTime(selectedStartTime.year, selectedStartTime.month,
            selectedStartTime.day, 20); //last end time is 8 pm==20
      }
      for (int i = selectedStartTime.hour + 1; i <= lastEndTime!.hour; i++) {
        endTimes.add(DateTime(selectedStartTime.year, selectedStartTime.month,
            selectedStartTime.day, i));
      }
    }
    return endTimes;
  }

  Future<bool> _createEvent() async {
    String snakbarText = "Failed to create event";
    SnackbarType snakbarTextType = SnackbarType.error;
    bool eventCreated = false;
    if (kDebugMode) {
      print("entered create Event function");
    }
    if (_formKey.currentState!.validate()) {
      String eventDateString =
          DateFormat('yyyy-MM-dd').format(widget.eventDate);
      Map<String, dynamic> eventMap = {
        DBKeys.eventName: _eventnameTextField.text.trim(),
        DBKeys.guestName: _organiserNameTextField.text.trim(),
        DBKeys.mobileNumber: _mobileNumberTextField.text.trim(),
        DBKeys.date: eventDateString,
        DBKeys.startTime: _selectedStartTime.toString(),
        DBKeys.endTime: _selectedEndTime.toString(),
        DBKeys.roomName: widget.roomName,
        DBKeys.status: RoomStatus.booked,
      };
      if (kDebugMode) {
        print(eventMap);
      }
      try {
        Map<String, dynamic> createdEventMap =
            await ApiService().postData(eventMap);
        if (createdEventMap.isNotEmpty) {
          eventCreated = true;
          snakbarTextType = SnackbarType.success;
          snakbarText = "Event created";
          logDebugMsg("$createdEventMap");
          final provider =
              navigatorKey.currentState!.context.read<UserStatusProvider>();
          provider.addEventData(createdEventMap);
          await sendSms(createdEventMap);
        }
      } catch (e) {
        logDebugMsg("error:$e");
      }
      logDebugMsg("Event created: $eventCreated");
    }
    CustomSnackbar.show(message: snakbarText, type: snakbarTextType);
    return eventCreated;
  }

  void disposeControllers(List<TextEditingController> list) {
    for (final controller in list) {
      controller.dispose();
    }
  }

  Future<void> sendSms(Map<String, dynamic> createdEventMap) async {
    FlutterNativeSms sms = FlutterNativeSms();
    String message = createMessage(createdEventMap);
    String phoneNumber = createdEventMap[DBKeys.mobileNumber];
    var status = await Permission.sms.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      // Request the permission if it’s not granted
      status = await Permission.sms.request();
    }
    if (await Permission.phone.status.isDenied) {
      await Permission.phone.request();
    }
    status = await Permission.sms.status;
    if (status.isGranted && await Permission.phone.status.isGranted) {
      try {
        var result =
            await sms.send(phone: phoneNumber, smsBody: message, sim: "0");
        logDebugMsg("result is  ......: $result");
      } catch (e) {
        if (kDebugMode) {
          logDebugMsg("Failed to send sms: $e");
        }
      }
    }
  }

  String createMessage(Map<String, dynamic> createdEventMap) {
    DateTime dateTime = DateTime.parse(createdEventMap[DBKeys.date]);
    DateTime startDateTime = DateTime.parse(createdEventMap[DBKeys.startTime]);
    DateTime endDateTime = DateTime.parse(createdEventMap[DBKeys.endTime]);
    String date = DateFormat('dd-MM-yyyy').format(dateTime);
    String startTime = DateFormat('h:mm a').format(startDateTime);
    String endTime = DateFormat('h:mm a').format(endDateTime);
    String otp = createdEventMap[DBKeys.id]
        .substring(createdEventMap[DBKeys.id].length - 4);

    String message =
        "${createdEventMap[DBKeys.guestName]}, your booking for ${createdEventMap[DBKeys.eventName]} is confirmed.\nDate: $date\nTime: $startTime - $endTime\nRoom: CRC ${createdEventMap[DBKeys.roomName]}\nOTP: $otp";
    logDebugMsg(message);
    logDebugMsg("length of message: ${message.length}");
    return message;
  }
}

void logDebugMsg(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
