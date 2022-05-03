import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shim_app/models/event.dart';
import 'package:shim_app/models/shimuser.dart';
// ignore: unused_import
import 'package:shim_app/ui/components/button.dart';
import 'package:shim_app/ui/components/input_field.dart';
import 'package:shim_app/ui/style/theme.dart';
import 'package:shim_app/ui/style/theme.dart';
import 'package:shim_app/ui/views/edit_event_view.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:stacked/stacked.dart';
import 'package:tuple/tuple.dart';

import '../../viewmodels/event_view_model.dart';
import '../widgets/busy_button.dart';

class EventDetailView extends StatefulWidget {
  // const EventDetailView({
  //   Key? key,
  //   // required this.event
  // }) : super(key: key);
  var eventObject;
  var eventRef;
  var user;
  bool going;

  EventDetailView(
      {this.eventObject, this.eventRef, this.user, required this.going});

  @override
  State<EventDetailView> createState() => _EventDetailViewState(
      eventObject: eventObject,
      eventRef: eventRef,
      user: this.user,
      going: this.going);
}

class _EventDetailViewState extends State<EventDetailView> {
  var eventObject;
  var eventRef;
  var user;
  var going;

  _EventDetailViewState(
      {required this.eventObject,
      required this.eventRef,
      required this.user,
      required this.going});

  @override
  Widget build(BuildContext context) {
    var event = eventObject;
    DocumentReference ref = eventRef;
    var user = this.user;
    bool going = this.going;
    var found = false;
    for (DocumentReference d in user.events) {
      if (d.id == ref.id) {
        found = true;
      }
    }
    return ViewModelBuilder<AddEventViewModel>.reactive(
        viewModelBuilder: () => AddEventViewModel(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: Colors.white,
            appBar: _appBar(context),
            body: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: FutureBuilder(
                    future: getData(),
                    builder: (context, AsyncSnapshot snapshot) {
                      return !snapshot.hasData
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                  Text(
                                    "Event Details",
                                    style: headingStyle,
                                  ),

                                  SizedBox(height: 12),
                                  Text(
                                    "Title:",
                                    style: captionStyle,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    snapshot.data["title"] as String,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Description:",
                                    style: captionStyle,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    snapshot.data["description"] as String,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  // const MyInputField(
                                  //     title: "Requirements", hint: "Enter your requirements"),
                                  SizedBox(height: 12),
                                  Text(
                                    "Location:",
                                    style: captionStyle,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    snapshot.data["location"] as String,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Date:",
                                    style: captionStyle,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    DateFormat('yyyy-MM-dd').format(
                                        snapshot.data["date"].toDate()
                                            as DateTime),
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 15),
                                    ),
                                  ),

                                  SizedBox(height: 12),
                                  Text(
                                    "Time:",
                                    style: captionStyle,
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "${snapshot.data["startTime"]} - ${snapshot.data["endTime"]}",
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Text(
                                    "Users Attending this Event:",
                                    style: captionStyle,
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      user.userRole == "Admin"
                                          ? FutureBuilder(
                                              future: getUserList(
                                                  snapshot.data["users"]),
                                              builder: (context,
                                                  AsyncSnapshot snaps) {
                                                return !snaps.hasData
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : Container(
                                                        height: 40,
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          shrinkWrap: true,
                                                          itemCount: snaps
                                                              .data?.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            ShimUser data =
                                                                snaps.data?[
                                                                    index];

                                                            return Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            8),
                                                                child:
                                                                    BusyButton(
                                                                  title: data
                                                                      .fullName!,
                                                                  busy: model
                                                                      .busy,
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          _buildPopupDialog(
                                                                              context,
                                                                              data),
                                                                    );
                                                                    // model.deleteEvent(
                                                                    //     id: event.id
                                                                    //         as String);
                                                                    // Navigator.pop(
                                                                    //     context);
                                                                  },
                                                                ));
                                                          },
                                                        ));
                                              },
                                            )
                                          : SizedBox(width: 12),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      user.userRole == "Admin"
                                          ? BusyButton(
                                              title: 'edit',
                                              busy: model.busy,
                                              onPressed: () {
                                                event = Event(
                                                    title:
                                                        snapshot.data["title"],
                                                    location: snapshot
                                                        .data["location"],
                                                    date: snapshot.data["date"]
                                                        .toDate(),
                                                    color:
                                                        snapshot.data["color"],
                                                    endTime: snapshot
                                                        .data["endTime"],
                                                    startTime: snapshot
                                                        .data["startTime"],
                                                    repeatType: snapshot
                                                        .data["repeatType"],
                                                    description: snapshot
                                                        .data["description"],
                                                    active: snapshot
                                                        .data["active"]);
                                                Navigator
                                                    .pushNamed(context,
                                                        'EditEventView',
                                                        arguments:
                                                            EditEventView(
                                                          eventObject: event,
                                                          eventRef: ref,
                                                        )).then(
                                                    (value) => setState(() {}));
                                              },
                                            )
                                          : SizedBox(width: 12),
                                      user.userRole == "Admin"
                                          ? BusyButton(
                                              title: 'delete',
                                              busy: model.busy,
                                              onPressed: () {
                                                model.deleteEvent(
                                                    id: event.id as String);
                                                Navigator.pop(context);
                                              },
                                            )
                                          : found
                                              ? BusyButton(
                                                  title: 'Undo',
                                                  busy: model.busy,
                                                  onPressed: () {
                                                    model.undoEventToUser(
                                                        e: ref);
                                                  },
                                                )
                                              //Container()
                                              : BusyButton(
                                                  title: 'Going',
                                                  busy: model.busy,
                                                  onPressed: () {
                                                    model.addEventToUser(
                                                        e: ref);
                                                  },
                                                )
                                    ],
                                  )
                                ]));
                    }))));
  }

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios,
                size: 20, color: Colors.black)));
  }

  Future getData() async {
    var data;
    //List<Tuple2<DocumentReference, DocumentSnapshot>> eventList = [];
    DocumentSnapshot datasnapshot = await eventRef.get();
    if (datasnapshot.exists) {
      if (datasnapshot.get("active") == true) {
        data = datasnapshot;
      }
    }
    return data;
  }

  Future getUserList(List<dynamic> ulist) async {
    var usersList = [];
    for (DocumentReference u in ulist) {
      DocumentSnapshot u_data = await u.get();
      ShimUser goingUser = ShimUser(
          fullName: u_data.get("fullName"),
          email: u_data.get("email"),
          phoneNumber: u_data.get("phoneNumber"));
      usersList.add(goingUser);
      //print(u_data.get("fullName"));
    }
    return usersList;
  }

  Widget _buildPopupDialog(BuildContext context, ShimUser data) {
    return AlertDialog(
      title: Text('User Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Full Name:",
            style: captionStyle,
          ),
          SizedBox(height: 12),
          Text(
            data.fullName!,
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Email:",
            style: captionStyle,
          ),
          SizedBox(height: 12),
          Text(
            data.email!,
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Phone Number:",
            style: captionStyle,
          ),
          SizedBox(height: 12),
          Text(
            data.phoneNumber!,
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text('Close'),
        ),
      ],
    );
  }
}
