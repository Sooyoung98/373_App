import 'package:shim_app/ui/views/add_event_view.dart';
import 'package:shim_app/ui/views/event_detail_view.dart';
import 'package:shim_app/ui/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:shim_app/constants/route_names.dart';
import 'package:shim_app/ui/views/login_view.dart';
import 'package:shim_app/ui/views/signup_view.dart';
import 'package:shim_app/ui/views/event_view.dart';
import 'package:shim_app/ui/views/profile_view.dart';
import 'package:shim_app/ui/views/main_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: SignUpView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: HomeView(),
      );
    case EventViewRoute:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: AddEventView(),
      );
    case ProfileViewRoute:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: ProfileView(user: settings.arguments),
      );
    case EventDetailViewRoute:
      var args = settings.arguments as EventDetailView;
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: EventDetailView(
            eventObject: args.eventObject, user: args.user, going: args.going),
      );
    case MainViewRoute:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: MainView(user: settings.arguments),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String? routeName, Widget? viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow!);
}
