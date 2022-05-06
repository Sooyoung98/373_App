import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shim_app/models/event.dart';
import 'package:shim_app/ui/components/button.dart';
import 'package:shim_app/ui/components/event_tile.dart';
import 'package:shim_app/ui/style/theme.dart';
import 'package:intl/intl.dart';
import 'package:shim_app/ui/views/event_detail_view.dart';
import 'package:shim_app/ui/widgets/event_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class EventView extends StatelessWidget {
  var user;

  EventView({this.user});

  @override
  Widget build(BuildContext context) {
    var user = this.user;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(children: [
            _addEventBar(context),
            SizedBox(
              height: 18,
            ),
            Row(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("events")
                      .where("active", isEqualTo: true)
                      .orderBy("date", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: ListView.builder(
                            // scrollDirection: Axis.vertical,
                            primary: false,
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot? data =
                                  snapshot.data?.docs[index];
                              DocumentReference? ref = data?.reference;
                              // if user.events
                              Event? temp = Event(
                                  id: data!.id,
                                  title: data['title'],
                                  location: data['location'],
                                  date: data['date'].toDate(),
                                  color: data['color'],
                                  endTime: data['endTime'],
                                  startTime: data['startTime'],
                                  repeatType: data['repeatType'],
                                  description: data['description'],
                                  users: data['users']);
                              return AnimationConfiguration.staggeredList(
                                  position: index,
                                  child: SlideAnimation(
                                      child: FadeInAnimation(
                                          child: Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, 'EventDetailView',
                                                arguments: EventDetailView(
                                                    eventObject: temp,
                                                    eventRef: ref,
                                                    user: user,
                                                    going: false));
                                          },
                                          child: EventTile(temp))
                                    ],
                                  ))));
                            },
                          ));
                  },
                ),
              ],
            )
          ]),
        ));
  }

  _showBottomSheet(BuildContext context, Event event) {
    Get.bottomSheet(Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height * 0.32,
        //MedMediaQuery.of(context).size.height*0.24 for
        color: Colors.white,
        child: Column(
          children: [
            Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300])),
            Spacer(),
            _bottomSheetButton(
              label: "View Event",
              onTap: () {
                Get.back();
              },
              clr: Colors.blue,
              context: context,
            ),
            _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                Get.back();
              },
              clr: Colors.red,
              context: context,
            ),
            SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red,
              context: context,
              isClose: true,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        )));
  }

  _bottomSheetButton({
    required String label,
    Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            height: 55,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 2, color: isClose == true ? Colors.grey : clr),
              borderRadius: BorderRadius.circular(20),
              color: isClose == true ? Colors.transparent : clr,
            ),
            child: Center(
                child: Text(
              label,
              style: isClose
                  ? titleStyle
                  : titleStyle.copyWith(color: Colors.white),
            ))));
  }

  _addEventBar(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(DateTime.now()),
                        style: subHeadingStyle,
                      ),
                      Text(
                        "Today",
                        style: headingStyle,
                      )
                    ])),
            user.userRole == "Admin"
                ? MyButton(
                    label: "+ Add Event",
                    onTap: () => Navigator.of(context).pushNamed('EventView'))
                : Container()
          ],
        ));
  }
}
