import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:shim_app/models/event.dart';
import 'package:shim_app/ui/components/event_tile.dart';
import 'package:shim_app/ui/style/theme.dart';
import 'package:shim_app/ui/views/event_detail_view.dart';

class HomeView extends StatelessWidget {
  var user;

  HomeView({this.user});

  @override
  Widget build(BuildContext context) {
    var user = this.user;
    Stream<DocumentSnapshot> UserInfoStream =
        Firestore.instance.collection('users').document(user.id).snapshots();
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
                StreamBuilder<DocumentSnapshot>(
                  stream: UserInfoStream,
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    return !snapshot.hasData
                        ? Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: ListView.builder(
                            // scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data?['events'].length,
                            itemBuilder: (context, index) {
                              var data = snapshot.data?['events'][index];

                              // if user.myEvents
                              Event? temp = Event(
                                  id: data!['id'],
                                  title: data['title'],
                                  location: data['location'],
                                  date: data['date'].toDate(),
                                  color: data['color'],
                                  endTime: data['endTime'],
                                  startTime: data['startTime'],
                                  repeatType: data['repeatType'],
                                  description: data['description']);
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
                                                    user: user));
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
                      Text(
                        DateFormat.yMMMMd().format(DateTime.now()),
                        style: subHeadingStyle,
                      ),
                      Text(
                        "Today",
                        style: headingStyle,
                      )
                    ])),
          ],
        ));
  }
}
