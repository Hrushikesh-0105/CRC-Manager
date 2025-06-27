import 'package:auto_size_text/auto_size_text.dart';
import 'package:crc_app/screens/events_page.dart';
import 'package:crc_app/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable_panel/flutter_slidable_panel.dart';

class FloorClassroomWidget2 extends StatefulWidget {
  final int floorNumber;
  const FloorClassroomWidget2({required this.floorNumber, super.key});

  @override
  State<FloorClassroomWidget2> createState() => _FloorClassroomWidget2State();
}

class _FloorClassroomWidget2State extends State<FloorClassroomWidget2> {
  final SlideController _slideController = SlideController();
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double boxWidth = deviceWidth - deviceWidth * 0.05;
    return Column(
      children: [
        SizedBox(
          height: 72,
          width: boxWidth,
          child: Card(
            elevation: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SlidablePanel(
                axis: Axis.horizontal,
                controller: _slideController,
                maxSlideThreshold: 1,
                // preActionLayout: ActionLayout(motion: motion, alignment: alignment),
                preActions: [
                  TextButton(
                    onPressed: () {
                      _slideController.dismiss();
                      setState(() {});
                      navigateToPage(context, widget.floorNumber, 1);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xffb6d5e1),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: AutoSizeText("${widget.floorNumber}-1",
                        style: slidableActionTextStyle()),
                  ),
                  TextButton(
                    onPressed: () {
                      _slideController.dismiss();
                      setState(() {});
                      navigateToPage(context, widget.floorNumber, 2);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xffe2eff1),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: AutoSizeText("${widget.floorNumber}-2",
                        style: slidableActionTextStyle()),
                  ),
                  TextButton(
                    onPressed: () {
                      _slideController.dismiss();
                      setState(() {});
                      navigateToPage(context, widget.floorNumber, 3);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xffb6d5e1),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: AutoSizeText(
                      "${widget.floorNumber}-3",
                      style: slidableActionTextStyle(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _slideController.dismiss();
                      setState(() {});
                      navigateToPage(context, widget.floorNumber, 4);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xffe2eff1),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: AutoSizeText(
                      "${widget.floorNumber}-4",
                      style: slidableActionTextStyle(),
                    ),
                  ),
                  Container(
                    color: prussianBlue,
                    child: Center(
                      child: IconButton(
                          onPressed: () {
                            _slideController.dismiss();
                          },
                          icon: const Icon(
                            Icons.keyboard_double_arrow_left_rounded,
                            color: Colors.white,
                          )),
                    ),
                  )
                ],

                child: GestureDetector(
                  onTap: () {
                    _slideController.open();
                  },
                  child: Container(
                    color: prussianBlue,
                    child: Center(
                        child: AutoSizeText(
                      "Floor ${widget.floorNumber}",
                      style: style3(),
                    )),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void navigateToPage(BuildContext context, int floorNumber, int roomNumber) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventsPage(
                  roomName: "$floorNumber-$roomNumber",
                )));
  }

  TextStyle slidableActionTextStyle() {
    return TextStyle(color: prussianBlue);
  }
}
