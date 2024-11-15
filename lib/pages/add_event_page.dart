import 'package:crc_app/CustomWidgets/floor_classroom_widget.dart';
import 'package:crc_app/pages/events_page.dart';
// import 'package:crc_app/pages/thirdPage.dart';
import 'package:crc_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddEventPage extends StatefulWidget {
  final floorNumber;
  final roomNumber;
  final DateTime eventDate;
  const AddEventPage(
      {required this.eventDate,
      required this.floorNumber,
      required this.roomNumber,
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
  TimeOfDay? eventStartTime;
  TimeOfDay? eventEndTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  // onTap: () async {
                  //   DateTime? pickedDate = await showDatePicker(
                  //       context: context,
                  //       initialDate: DateTime.now(),
                  //       firstDate: DateTime(2024),
                  //       lastDate: DateTime(DateTime.now().year + 50));
                  //   if (pickedDate != null) {
                  //     eventDateTextField.text =
                  //         "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  //     eventDate = pickedDate;
                  //   }
                  // },
                  decoration: textfieldstyle1(
                      Icons.edit_calendar_rounded, "Event Date"),
                  style: style1(),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return "Field cannot be empty";
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: eventStartTimeTextField,
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: eventStartTime ?? TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            eventStartTime = pickedTime;
                            eventStartTimeTextField.text =
                                "${pickedTime.hour}:${pickedTime.minute}";
                          }
                        },
                        decoration:
                            textfieldstyle1(Icons.timer_sharp, "Start Time"),
                        style: style1(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field cannot be empty";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: eventEndTimeTextField,
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: eventEndTime ?? TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            eventEndTime = pickedTime;
                            eventEndTimeTextField.text =
                                "${pickedTime.hour}:${pickedTime.minute}";
                            // "${eventEndTime}";
                          }
                        },
                        decoration: textfieldstyle1(
                            Icons.timer_off_outlined, "End Time"),
                        style: style1(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field cannot be empty";
                          }
                          return null;
                        },
                      ),
                    ),
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
                  onPressed: () {
                    _createEvent();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(deviceWidth - 2 * boxPadding, deviceHeight * 0.06),
                    backgroundColor: prussianBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // Rounded corners
                    ),
                    elevation: 5, // Elevation (shadow)
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

  void _createEvent() {
    if (_formKey.currentState!.validate()) {}
  }
}
