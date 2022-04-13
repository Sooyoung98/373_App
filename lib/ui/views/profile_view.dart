import 'package:flutter/material.dart';
import 'package:shim_app/ui/components/button.dart';
import 'package:shim_app/ui/widgets/busy_button.dart';
import 'package:shim_app/viewmodels/auth_view_model.dart';
import 'package:shim_app/viewmodels/event_view_model.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
        viewModelBuilder: () => AuthViewModel(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BusyButton(
                        title: 'Logout',
                        busy: model.busy,
                        onPressed: () {
                          model.logout();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
