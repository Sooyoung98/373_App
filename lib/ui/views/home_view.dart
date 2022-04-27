import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:shim_app/models/event.dart';
import 'package:shim_app/models/user.dart';
import 'package:shim_app/ui/components/event_tile.dart';
import 'package:shim_app/ui/style/theme.dart';
import 'package:shim_app/ui/views/event_detail_view.dart';
import 'package:tuple/tuple.dart';

class HomeView extends StatelessWidget {
  var user;

  HomeView({this.user});

  @override
  Widget build(BuildContext context) {
    var user = this.user;
    // Stream<DocumentSnapshot> UserInfoStream =
    //     Firestore.instance.collection('users').document(user.id).snapshots();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(children: [
            _addHomeBar(context),
            SizedBox(
              height: 18,
            ),
            Row(
              children: [
                FutureBuilder(
                  future: getList(user),
                  builder: (context, AsyncSnapshot snapshot) {
                    return !snapshot.hasData
                        ? Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: ListView.builder(
                            // scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              var data = snapshot.data?[index];
                              Event? temp = Event(
                                  id: data.item2.data!['id'],
                                  title: data.item2.data['title'],
                                  location: data.item2.data['location'],
                                  date: data.item2.data['date'].toDate(),
                                  color: data.item2.data['color'],
                                  endTime: data.item2.data['endTime'],
                                  startTime: data.item2.data['startTime'],
                                  repeatType: data.item2.data['repeatType'],
                                  description: data.item2.data['description']);

                              // docRef.get().then((DocumentSnapshot snap) {
                              //   if (snap.exists) {
                              //     Event? temp = Event(
                              //         id: snap['id'],
                              //         title: snap['title'],
                              //         location: snap['location'],
                              //         date: snap['date'].toDate(),
                              //         color: snap['color'],
                              //         endTime: snap['endTime'],
                              //         startTime: snap['startTime'],
                              //         repeatType: snap['repeatType'],
                              //         description: snap['description']);
                              //     e.add(temp);
                              //   }
                              // });

                              return AnimationConfiguration.staggeredList(
                                  position: index,
                                  child: SlideAnimation(
                                      child: FadeInAnimation(
                                          child: Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            // _showBottomSheet(context, temp);
                                            // Navigator.of(context)
                                            //     .pushNamed('EventDetailView');
                                            // Navigator.pushNamed(
                                            //     context, 'EventDetailView',
                                            //     arguments: EventDetailView(
                                            //       event: temp,
                                            //     ));
                                            Navigator.pushNamed(
                                                context, 'EventDetailView',
                                                arguments: EventDetailView(
                                                    eventObject: temp,
                                                    eventRef: data.item1,
                                                    user: user,
                                                    going: true));
                                          },
                                          child: EventTile(temp))
                                    ],
                                  ))));
                              // return EventWidget(
                              // title: data!['title'],
                              // location: data['location'],
                              // date: data['date'].toDate(),
                              // color: data['color'],
                              // endTime: data['endTime'],
                              // startTime: data['startTime'],
                              // repeatType: data['repeatType'],
                              // description: data['description']);
                            },
                          ));
                  },
                ),
              ],
            )
          ]),
        ));
  }

  Future getList(User u) async {
    List<Tuple2<DocumentReference, DocumentSnapshot>> eventList = [];
    for (DocumentReference e in u.events!) {
      DocumentSnapshot datasnapshot = await e.get();
      if (datasnapshot.exists) {
        if (datasnapshot.data["active"] == true) {
          var t = Tuple2<DocumentReference, DocumentSnapshot>(e, datasnapshot);
          eventList.add(t);
        }
      }
    }
    return eventList;
  }

  _addHomeBar(BuildContext context) {
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
                      // Text(
                      //   DateFormat.yMMMMd().format(DateTime.now()),
                      //   style: subHeadingStyle,
                      // ),
                      Text(
                        "Your Events",
                        style: headingStyle,
                      )
                    ])),
          ],
        ));
  }
}
