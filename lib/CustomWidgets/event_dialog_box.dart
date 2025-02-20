import 'package:auto_size_text/auto_size_text.dart';
import 'package:crc_app/Api/api.dart';
import 'package:crc_app/CustomWidgets/snack_bar.dart';
import 'package:crc_app/main.dart';
import 'package:crc_app/styles.dart';
import 'package:crc_app/userStatusProvider/user_and_event_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:crc_app/userStatusProvider/db_keys_room_status.dart';

class EventDialogBox extends StatefulWidget {
  final Map<String, dynamic> currentEventMap;
  final bool isAdmin;
  const EventDialogBox(
      {required this.currentEventMap, required this.isAdmin, super.key});

  @override
  State<EventDialogBox> createState() => _EventDialogBoxState();
}

class _EventDialogBoxState extends State<EventDialogBox> {
  bool _isLoading = false;
  TextEditingController otpTextField = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    logDebugMsg("Entered event dialog box");
    otpTextField.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      logDebugMsg("${widget.currentEventMap}");
    }
    DateTime currentEventDate =
        DateTime.parse(widget.currentEventMap[DBKeys.date]);
    DateTime currentStartTime =
        DateTime.parse(widget.currentEventMap[DBKeys.startTime]);
    DateTime currentEndTime =
        DateTime.parse(widget.currentEventMap[DBKeys.endTime]);
    String currentStartTimeString =
        "${currentStartTime.hour <= 12 ? currentStartTime.hour : currentStartTime.hour - 12}:00 ${currentStartTime.hour < 12 ? "AM" : "PM"}";
    String currentEndTimeString =
        "${currentEndTime.hour <= 12 ? currentEndTime.hour : currentEndTime.hour - 12}:00 ${currentEndTime.hour < 12 ? "AM" : "PM"}";
    String statusString;
    if (widget.currentEventMap[DBKeys.status] == RoomStatus.booked) {
      statusString = RoomStatus.booked;
    } else if (widget.currentEventMap[DBKeys.status] == RoomStatus.inUse) {
      statusString = "In Use";
    } else {
      statusString = "Free";
    }
    String currentId = widget.currentEventMap[DBKeys.id];
    String currentOTP =
        currentId.substring(currentId.length - 4, currentId.length);
    return AlertDialog(
      backgroundColor: backgroundColor,
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                  child: _isLoading
                      ? loadingIndicatorWidget()
                      : IconButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            bool eventDeleted = await deleteEvent(currentId);
                            if (eventDeleted) {
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
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
                child: AutoSizeText(
                  "${widget.currentEventMap[DBKeys.eventName]}",
                  maxLines: 1,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
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
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_isLoading == false) {
                              Navigator.pop(context);
                            }
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
        // mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isAdmin)
            Center(
                child: Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: prussianBlue)),
                    child: TextRichEventDialog(
                        heading: "OTP", value: currentOTP))),
          TextRichEventDialog(
            heading: "Organiser",
            value: widget.currentEventMap[DBKeys.guestName],
          ),
          TextRichEventDialog(
            heading: "Mobile No.",
            value: widget.currentEventMap[DBKeys.mobileNumber] ?? "null",
          ),
          TextRichEventDialog(
              heading: "Event Date",
              value:
                  "${currentEventDate.day}-${currentEventDate.month}-${currentEventDate.year}"),
          TextRichEventDialog(
              heading: "Start Time", value: currentStartTimeString),
          TextRichEventDialog(heading: "End Time", value: currentEndTimeString),
          TextRichEventDialog(heading: "Status", value: statusString),
          if (!widget.isAdmin &&
              widget.currentEventMap[DBKeys.status] != RoomStatus.keysReturned)
            const SizedBox(
              height: 10,
            ),
          if (!widget.isAdmin &&
              widget.currentEventMap[DBKeys.status] == RoomStatus.booked)
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    cursorColor: prussianBlue,
                    controller: otpTextField,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: textfieldstyle1(
                        prefixicon: Icons.lock_outlined, hinttext: "OTP"),
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
                  _isLoading
                      ? loadingIndicatorWidget()
                      : SizedBox(
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
                              setState(() {
                                _isLoading = true;
                              });
                              bool otpVerified = await verifyOtp(
                                  widget.currentEventMap[DBKeys.id],
                                  otpTextField.text.trim(),
                                  currentOTP);
                              if (otpVerified) {
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            child: AutoSizeText(
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
          if (!widget.isAdmin &&
              widget.currentEventMap[DBKeys.status] == RoomStatus.inUse)
            _isLoading
                ? loadingIndicatorWidget()
                : SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        bool keysReturned =
                            await returnKeys(widget.currentEventMap[DBKeys.id]);
                        if (keysReturned) {
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: prussianBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          // Rounded corners
                        ),
                        elevation: 5, // Elevation (shadow)
                      ),
                      child: AutoSizeText(
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

  Future<bool> deleteEvent(String id) async {
    SnackbarType snakbarTextType = SnackbarType.error;
    bool eventDeleted;
    String snakbarText = "Failed to delete";
    if (kDebugMode) {
      logDebugMsg(id);
    }
    try {
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
    CustomSnackbar.show(message: snakbarText, type: snakbarTextType);
    return eventDeleted;
  }

  Future<bool> verifyOtp(String id, String enteredOtp, String actualOtp) async {
    SnackbarType snakbarTextType = SnackbarType.error;
    bool verified = false;
    String snakbarText = "Wrong Otp";
    if (enteredOtp == actualOtp) {
      logDebugMsg("Otp verified");
      try {
        verified = await ApiService().updateBookingStatus(id, RoomStatus.inUse);
        if (verified) {
          final provider =
              navigatorKey.currentState!.context.read<UserStatusProvider>();
          provider.updateEventStatusById(id, RoomStatus.inUse);
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
    CustomSnackbar.show(message: snakbarText, type: snakbarTextType);
    return verified;
  }

  Future<bool> returnKeys(String id) async {
    SnackbarType snakbarTextType = SnackbarType.error;
    bool keysReturned = false;
    String snakbarText = "Keys Not Returned";
    try {
      keysReturned =
          await ApiService().updateBookingStatus(id, RoomStatus.keysReturned);
      if (keysReturned) {
        final provider =
            navigatorKey.currentState!.context.read<UserStatusProvider>();
        provider.updateEventStatusById(id, RoomStatus.keysReturned);
        snakbarText = "Keys Returned";
      }
    } catch (e) {
      snakbarText = "NetWork Error";
      logDebugMsg("$e");
    }
    if (keysReturned) snakbarTextType = SnackbarType.success;
    CustomSnackbar.show(message: snakbarText, type: snakbarTextType);
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
        text: '$heading : ',
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
      softWrap: true,
    );
  }
}

void logDebugMsg(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
