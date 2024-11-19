import 'package:crc_app/pages/events_page.dart';
import 'package:crc_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FloorClassroomWidget extends StatefulWidget {
  final floorNumber;
  const FloorClassroomWidget({required this.floorNumber, super.key});

  @override
  State<FloorClassroomWidget> createState() => _FloorClassroomWidgetState();
}

class _FloorClassroomWidgetState extends State<FloorClassroomWidget> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double boxWidth = deviceWidth - deviceWidth * 0.05;
    return Column(
      children: [
        Container(
          height: 68,
          width: boxWidth,
          decoration: BoxDecoration(
            // color: prussianBlue,

            borderRadius: BorderRadius.circular(10),

            // border: Border.all(color: prussianBlue)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Slidable(
              // controller: _controller,
              endActionPane: ActionPane(
                extentRatio: 1,
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    flex: 1,
                    onPressed: (context) {},
                    backgroundColor: prussianBlue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.only(left: 0),
                    icon: Icons.keyboard_double_arrow_right_rounded,
                    // label: 'close',
                  ),
                  SlidableAction(
                    flex: 2,
                    onPressed: (context) {
                      navigateToPage(context, widget.floorNumber, 1);
                    },
                    backgroundColor: const Color(0xffe2eff1),
                    foregroundColor: prussianBlue,
                    label: '${widget.floorNumber}-1',
                  ),
                  SlidableAction(
                    flex: 2,
                    onPressed: (context) {
                      navigateToPage(context, widget.floorNumber, 2);
                    },
                    backgroundColor: const Color(0xffb6d5e1),
                    foregroundColor: prussianBlue,
                    label: '${widget.floorNumber}-2',
                  ),
                  SlidableAction(
                    flex: 2,
                    onPressed: (context) {
                      navigateToPage(context, widget.floorNumber, 3);
                    },
                    backgroundColor: const Color(0xffe2eff1),
                    foregroundColor: prussianBlue,
                    label: '${widget.floorNumber}-3',
                  ),
                  SlidableAction(
                    flex: 2,
                    onPressed: (context) {
                      navigateToPage(context, widget.floorNumber, 4);
                    },
                    backgroundColor: const Color(0xffb6d5e1),
                    foregroundColor: prussianBlue,
                    label: '${widget.floorNumber}-4',
                  ),
                ],
              ),
              // controller: _controller,
              child: Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    //this doesnt work without builder because(i.e we cannot open the action pane by a function )
                    //This exception happens because you are using the context of the widget that instantiated Scaffold. Not the context of a child of Scaffold.
                    Slidable.of(context)?.openEndActionPane();
                  },
                  child: Container(
                    color: prussianBlue,
                    child: Center(
                        child: Text(
                      "Floor ${widget.floorNumber}",
                      style: style3(),
                    )),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  void navigateToPage(BuildContext context, int floorNumber, int roomNumber) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventsPage(
                floorNumber: widget.floorNumber, roomNumber: roomNumber)));
  }
}
