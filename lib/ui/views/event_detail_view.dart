import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shim_app/models/event.dart';
// ignore: unused_import
import 'package:shim_app/ui/components/button.dart';
import 'package:shim_app/ui/components/input_field.dart';
import 'package:shim_app/ui/style/theme.dart';
import 'package:shim_app/ui/style/theme.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:stacked/stacked.dart';

import '../../viewmodels/event_view_model.dart';
import '../widgets/busy_button.dart';

class EventDetailView extends StatelessWidget {
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
  // final Event event;

  @override
  Widget build(BuildContext context) {
    var event = this.eventObject;
    DocumentReference ref = this.eventRef;
    var user = this.user;
    bool going = this.going;
    var found = false;
    for (DocumentReference d in user.events) {
      if (d.documentID == ref.documentID) {
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
                child: SingleChildScrollView(
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
                        event.title as String,
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
                        event.description as String,
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
                        event.location as String,
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
                        DateFormat('yyyy-MM-dd').format(event.date as DateTime),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${event.startTime} - ${event.endTime}",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 12),
                          user.userRole == "Admin"
                              ? BusyButton(
                                  title: 'delete',
                                  busy: model.busy,
                                  onPressed: () {
                                    model.deleteEvent(id: event.id as String);
                                    Navigator.pop(context);
                                  },
                                )
                              : found
                                  ? BusyButton(
                                      title: 'Undo',
                                      busy: model.busy,
                                      onPressed: () {
                                        model.undoEventToUser(e: ref);
                                      },
                                    )
                                  //Container()
                                  : BusyButton(
                                      title: 'Going',
                                      busy: model.busy,
                                      onPressed: () {
                                        model.addEventToUser(e: ref);
                                      },
                                    )
                        ],
                      )
                    ])))));
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
}
