import 'package:firebase_core/firebase_core.dart';
import 'package:shim_app/firebase_options.dart';
import 'package:shim_app/ui/views/login_view.dart';
import 'package:shim_app/ui/views/startup_view.dart';
import 'package:shim_app/ui/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:shim_app/services/navigation_service.dart';
import 'package:shim_app/services/dialog_service.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';
import 'locator.dart';
import 'ui/style/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  // Register all the models and services before the app starts
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHIM App',
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child!)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        backgroundColor: AppColors.backgroundColor,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
            ),
      ),
      home: LoginView(),
      onGenerateRoute: generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
