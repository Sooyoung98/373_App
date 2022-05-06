import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shim_app/services/firestore_service.dart';
import 'package:shim_app/ui/components/button.dart';
import 'package:shim_app/ui/style/theme.dart';
import 'package:shim_app/ui/views/profile_edit_view.dart';
import 'package:shim_app/ui/widgets/busy_button.dart';
import 'package:shim_app/viewmodels/auth_view_model.dart';
import 'package:shim_app/viewmodels/event_view_model.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  var user;
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  ProfileView({this.user});

  @override
  Widget build(BuildContext context) {
    var user = this.user;
    return ViewModelBuilder<AuthViewModel>.reactive(
        viewModelBuilder: () => AuthViewModel(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: Colors.white,
            body: Container(
                padding: const EdgeInsets.only(left: 30, right: 25),
                child: FutureBuilder(
                    future: getData(),
                    builder: (context, AsyncSnapshot snapshot) {
                      return !snapshot.hasData
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 20),
                                    Text(
                                      "Profile",
                                      style: headingStyle,
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 12),
                                        CircleAvatar(
                                            radius: 80,
                                            foregroundImage: AssetImage(
                                              'assets/images/smiling.png',
                                            ),
                                            backgroundColor: Colors.grey),
                                        SizedBox(width: 12),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "Name:",
                                      style: captionStyle,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      snapshot.data["fullName"] as String,
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
                                      snapshot.data["email"] as String,
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
                                      snapshot.data["phoneNumber"] as String,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "Birthday:",
                                      style: captionStyle,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      formatter.format(
                                          snapshot.data["birthday"].toDate()),
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        BusyButton(
                                          title: 'Edit Profile',
                                          busy: model.busy,
                                          onPressed: () {
                                            // Navigator.of(context).push(MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         ProfileEditView(user: user)));
                                            Navigator.pushNamed(
                                                context, 'ProfileEditView',
                                                arguments: ProfileEditView(
                                                    user: user));
                                          },
                                        ),
                                        SizedBox(width: 12),
                                        BusyButton(
                                          title: 'Logout',
                                          busy: model.busy,
                                          onPressed: () {
                                            model.logout();
                                          },
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.center,
                                    //   children: [
                                    //     SizedBox(width: 12),
                                    //     BusyButton(
                                    //       title: 'Edit Profile',
                                    //       busy: model.busy,
                                    //       onPressed: () {
                                    //         // Navigator.of(context).push(MaterialPageRoute(
                                    //         //     builder: (context) =>
                                    //         //         ProfileEditView(user: user)));
                                    //         Navigator.pushNamed(
                                    //             context, 'ProfileEditView',
                                    //             arguments:
                                    //                 ProfileEditView(user: user));
                                    //       },
                                    //     ),
                                    //   ],
                                    // )
                                  ]));
                    }))));
  }

  Future getData() async {
    var data;
    DocumentSnapshot datasnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.id).get();
    user = await FirestoreService().getUser(user.id);
    if (datasnapshot.exists) {
      data = datasnapshot;
    }
    return data;
  }
}
