import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shim_app/ui/components/button.dart';
import 'package:shim_app/ui/style/theme.dart';
import 'package:shim_app/ui/widgets/busy_button.dart';
import 'package:shim_app/viewmodels/auth_view_model.dart';
import 'package:shim_app/viewmodels/event_view_model.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  var user;

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
                child: SingleChildScrollView(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 12),
                          CircleAvatar(
                              radius: 80, backgroundColor: Colors.grey),
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
                        user.fullName as String,
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
                        user.email as String,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 15),
                        ),
                      ),
                      // const MyInputField(
                      //     title: "Requirements", hint: "Enter your requirements"),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 12),
                          BusyButton(
                            title: 'Logout',
                            busy: model.busy,
                            onPressed: () {
                              model.logout();
                            },
                          ),
                        ],
                      )
                    ])))));
  }
}
