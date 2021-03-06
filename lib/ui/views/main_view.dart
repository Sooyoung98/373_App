// ignore: import_of_legacy_library_into_null_safe
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:stacked/stacked.dart';

import 'package:shim_app/viewmodels/main_view_model.dart';

import 'package:shim_app/ui/views/profile_view.dart';
import 'package:shim_app/ui/views/event_view.dart';
import 'package:shim_app/ui/views/home_view.dart';
import 'package:shim_app/ui/views/admin_home_view.dart';
import 'package:shim_app/ui/style/theme.dart';

class MainView extends StatelessWidget {
  var user;
  var msg;

  MainView({this.user, this.msg});

  @override
  Widget build(BuildContext context) {
    var user = this.user;
    return ViewModelBuilder<MainViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: _appBar(),
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          reverse: model.reverse,
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
            );
          },
          child: getViewForIndex(model.currentIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: model.currentIndex,
          selectedItemColor: AppColors.accentColor,
          unselectedItemColor: AppColors.backgroundColor,
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          onTap: model.setIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
      viewModelBuilder: () => MainViewModel(),
    );
  }

  _appBar() {
    return AppBar(
      title: const Text('SHIM'),
      backgroundColor: AppColors.primaryColor,
      automaticallyImplyLeading: false,
    );
  }

  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return user.userRole == "Admin"
            ? AdminHomeView(user: user)
            : HomeView(user: user, msg: msg);
      case 1:
        return EventView(user: user);
      case 2:
        return ProfileView(user: user);
      default:
        return user.userRole == "Admin"
            ? AdminHomeView(user: user)
            : HomeView(user: user, msg: msg);
    }
  }
}
